{
  lib,
  config,
  pkgs,
  vars,
  ...
}: let
  cfg = config.my.econIngest;
  bin = "${cfg.repoDir}/.venv/bin/econ-ingest";

  # Same runtime environment for every unit: manylinux wheels (torch, numpy,
  # psycopg-binary) need libstdc++/zlib, the backup needs pg_dump.
  common = {
    User = vars.user;
    WorkingDirectory = cfg.repoDir;
  };
  env = {
    LD_LIBRARY_PATH = lib.makeLibraryPath [pkgs.stdenv.cc.cc.lib pkgs.zlib];
  };

  # `ssh esprimo econ-mcp` starts the MCP server on stdio (the SDK passes clients a minimal environment, so set it here).
  mcpWrapper = pkgs.writeShellScriptBin "econ-mcp" ''
    export LD_LIBRARY_PATH=${lib.makeLibraryPath [pkgs.stdenv.cc.cc.lib pkgs.zlib]}
    export HF_HUB_OFFLINE=1
    cd ${cfg.repoDir}
    exec .venv/bin/econ-mcp "$@"
  '';

  mkTimer = description: onCalendar: extra: {
    inherit description;
    wantedBy = ["timers.target"];
    timerConfig = {OnCalendar = onCalendar;} // extra;
  };
  mkOneshot = description: script: {
    inherit description;
    after = ["econ-ingest-db.service"];
    requires = ["econ-ingest-db.service"];
    environment = env;
    path = [pkgs.postgresql_17 pkgs.gzip pkgs.coreutils pkgs.findutils];
    serviceConfig = common // {Type = "oneshot";} // script;
  };
  mkDaemon = description: exec: {
    inherit description;
    wantedBy = ["multi-user.target"];
    after = ["network-online.target" "econ-ingest-db.service"];
    wants = ["network-online.target"];
    requires = ["econ-ingest-db.service"];
    environment = env;
    serviceConfig =
      common
      // {
        ExecStart = exec;
        Restart = "always";
        RestartSec = 20;
      };
  };
in {
  options.my.econIngest = {
    enable = lib.mkEnableOption "econ-ingest (worker, embed, alerts, timers, Postgres container, self-hosted ntfy)";
    repoDir = lib.mkOption {
      type = lib.types.str;
      default = "/home/${vars.user}/Documents/EDB/ingest";
      description = "Checkout of EDB/ingest with .venv and .env (the app reads .env itself).";
    };
    llm = lib.mkEnableOption "LLM phrasing of the daily briefing (needs an NVIDIA GPU)";
    ntfy = {
      baseUrl = lib.mkOption {
        type = lib.types.str;
        example = "http://esprimo.<tailnet>.ts.net:2586";
        description = "URL the phone uses to reach ntfy (tailnet name).";
      };
      port = lib.mkOption {
        type = lib.types.port;
        default = 2586;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Tools for creating/refreshing the venv: `uv venv --python python3.12 .venv`
    # (a system python keeps the venv's interpreter from being garbage-collected).
    environment.systemPackages = [pkgs.uv pkgs.postgresql_17 mcpWrapper];

    # ntfy: reachable only over the tailnet (open topic, secret random name);
    # econ-ingest posts to it on localhost.
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = cfg.ntfy.baseUrl;
        listen-http = ":${toString cfg.ntfy.port}";
        behind-proxy = false;
      };
    };
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [cfg.ntfy.port];

    systemd.services = {
      # The compose file (pgvector/pgvector:pg17, 127.0.0.1:55433, volume ingest_econ_pgdata)
      # stays the single definition; this unit just brings it up at boot.
      econ-ingest-db = {
        description = "econ-ingest Postgres 17 + pgvector (docker compose)";
        wantedBy = ["multi-user.target"];
        after = ["docker.service"];
        requires = ["docker.service"];
        path = [pkgs.docker];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          WorkingDirectory = cfg.repoDir;
          ExecStart = "${pkgs.docker}/bin/docker compose --env-file .env up -d --wait";
          ExecStop = "${pkgs.docker}/bin/docker compose --env-file .env stop";
          TimeoutStartSec = 120;
        };
      };

      econ-ingest-worker = mkDaemon "econ-ingest worker (scheduler and fetchers)" "${bin} worker --concurrency 6";
      econ-ingest-embed = mkDaemon "econ-ingest embedding worker" "${bin} embed --loop --interval 30";
      econ-ingest-alerts =
        mkDaemon "econ-ingest alert engine" "${bin} alerts watch --interval 300 --evidence bge-m3"
        // {after = ["network-online.target" "econ-ingest-db.service" "econ-ingest-worker.service"];};

      econ-ingest-maintenance = mkOneshot "econ-ingest daily maintenance" {
        ExecStart = [
          "${bin} rollup --keep-days 90"
          "${bin} retention --days 30"
          "-${bin} check-staleness"
          "-${bin} cross-check"
          "-${bin} company risk"
          "-${bin} extracts --limit 60"
          "-${bin} edinet update --days 10"
          "-${bin} dart update"
          "-${bin} esef update"
          "-${cfg.repoDir}/.venv/bin/econ-mcp sync"
        ];
      };
      econ-ingest-brief = mkOneshot "econ-ingest daily briefing" {
        ExecStart = "${bin} lab daily${lib.optionalString cfg.llm " --llm"}";
      };
      econ-ingest-digest = mkOneshot "econ-ingest weekly alert digest" {
        ExecStart = "${bin} alerts digest --hours 168 --send";
      };
      econ-ingest-health = mkOneshot "econ-ingest health checks" {
        ExecStart = "${bin} health --record";
      };
      econ-ingest-backup = mkOneshot "econ-ingest backup" {
        # Same script as deploy/econ-ingest-backup.service; backups land in ${cfg.repoDir}/backups.
        ExecStart = pkgs.writeShellScript "econ-ingest-backup" ''
          set -e
          set -a; . ./.env; set +a
          mkdir -p backups
          pg_dump --schema=lab --schema=alert --schema=ops "$DATABASE_URL" | gzip > backups/ledger-$(date +%F).sql.gz
          if [ "$(date +%u)" = 7 ]; then pg_dump "$DATABASE_URL" | gzip > backups/full-$(date +%F).sql.gz; fi
          find backups -name 'ledger-*' -mtime +30 -delete
          find backups -name 'full-*' -mtime +35 -delete
        '';
      };
    };

    systemd.timers = {
      econ-ingest-maintenance = mkTimer "econ-ingest maintenance, 04:15" "*-*-* 04:15:00" {Persistent = true;};
      econ-ingest-brief = mkTimer "Daily briefing, 06:30" "*-*-* 06:30:00" {Persistent = true;};
      econ-ingest-digest = mkTimer "Weekly alert digest, Monday 07:00" "Mon *-*-* 07:00:00" {Persistent = true;};
      econ-ingest-health = mkTimer "Hourly health checks" "hourly" {
        Persistent = true;
        RandomizedDelaySec = 300;
      };
      econ-ingest-backup = mkTimer "Daily backup, 03:30" "*-*-* 03:30:00" {Persistent = true;};
    };
  };
}
