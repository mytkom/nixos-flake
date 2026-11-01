{
  inputs,
  outputs,
  vars,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
  ];

  # Headless server: Home Manager is applied by nixos-rebuild (no separate
  # `home-manager switch` needed over SSH).
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs outputs vars;};
    users.${vars.user}.imports = [
      outputs.homeManagerModules.base
      ./home.nix
    ];
  };

  networking = {
    hostName = "esprimo";
    firewall = {
      enable = true;
      allowPing = true;
      checkReversePath = false;
      allowedTCPPorts = [8384 22000 9090 11434 3333 445 3456 8001 7272];
      allowedUDPPorts = [22000 21027];
    };
    # wg-quick.interfaces.proton = {
    #   autostart = true;
    #   configFile = "/root/nixos-flake/proton.conf";
    # };
  };

  my = {
    tailscale.enable = true;
    ssh = {
      enable = true;
      # TODO: switch to key-only auth once authorizedKeys are set for mytkom.
      passwordAuthentication = true;
    };
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  users.users.mytkom = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "tty" "video" "audio" "docker" "input"];
  };
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    git
    zip
    unzip
    btop
    vim
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  # Reverse proxy for the local web apps
  services.nginx = {
    enable = true;
    virtualHosts."localhost" = {
      root = "/var/www";
      enableACME = false;
      locations = {
        "/nlp" = {
          proxyPass = "http://127.0.0.1:8501";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_redirect off;
          '';
        };
        "/bigdata" = {
          proxyPass = "http://127.0.0.1:8502";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_redirect off;
          '';
        };
        "/datasette/" = {
          proxyPass = "http://127.0.0.1:8001";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_redirect off;
          '';
        };
      };
    };
  };

  services.vikunja = {
    enable = true;
    frontendHostname = "localhost";
    frontendScheme = "http";
    database.type = "sqlite";
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        security = "user";
        workgroup = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        # "max protocol" = "smb2";
        "hosts allow" = "192.168.8. 127.0.0.1 localhost levicorpus nothing-a063 laura";
        "hosts deny" = "0.0.0.0/0";
      };
      private = {
        path = "/home/${vars.user}";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = vars.user;
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  services.syncthing = {
    enable = true;
    user = vars.user;
    dataDir = "/home/${vars.user}/";
    configDir = "/home/${vars.user}/.config/syncthing";
    guiAddress = "0.0.0.0:8384";
  };

  services.cockpit = {
    enable = true;
    port = 9090;
    settings.WebService.AllowUnencrypted = true;
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = vars.user;
  };

  services.ollama = {
    enable = true;
    host = "0.0.0.0";
    port = 11434;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [vars.user "bigdata"];

  system.stateVersion = "23.11";
}
