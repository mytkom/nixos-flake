{
  lib,
  config,
  ...
}: {
  options.my.selfhosted.enable = lib.mkEnableOption "Wealthfolio and Ferdium server containers";

  config = lib.mkIf config.my.selfhosted.enable {
    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";

    virtualisation.oci-containers.containers = {
      # Wealthfolio 3.11.0. Data lives in the pre-existing named volume.
      # Secrets (WF_SECRET_KEY, WF_AUTH_PASSWORD_HASH) are in a root-only env file.
      wealthfolio = {
        image = "ghcr.io/wealthfolio/wealthfolio@sha256:3e996e9b3fbf9c945eca89e7b89eb03e0966beb1c51b977ccccb811f76ae2994";
        ports = ["7272:8088"];
        user = "1000:1000";
        volumes = ["wealthfolio-data:/data"];
        environment = {
          WF_DB_PATH = "/data/wealthfolio.db";
          WF_CORS_ALLOW_ORIGINS = "http://localhost:7272";
          CONNECT_API_URL = "https://api.wealthfolio.app";
        };
        environmentFiles = ["/var/lib/secrets/wealthfolio.env"];
      };

      # Ferdium server 2.0.14 (SQLite). Secrets (DB_PASSWORD, MAIL_PASSWORD,
      # JWT_USE_PEM) are in a root-only env file.
      ferdium-server = {
        image = "ferdium/ferdium-server@sha256:06dcf64cb84c1720e03d18e63fcdf60dd9d80069777b2047d129c53cb726d87c";
        ports = ["3333:3333"];
        volumes = [
          "docker_ferdium-database-vol:/data"
          "docker_ferdium-recipes-vol:/app/build/recipes"
        ];
        environment = {
          NODE_ENV = "production";
          HOST = "0.0.0.0";
          PORT = "3333";
          APP_URL = "<ferdium-server-url>"; # TODO: set the real URL
          DATA_DIR = "/data";
          DB_CONNECTION = "sqlite";
          DB_HOST = "127.0.0.1";
          DB_PORT = "3306";
          DB_USER = "root";
          DB_DATABASE = "ferdium";
          DB_SSL = "false";
          IS_CREATION_ENABLED = "true";
          IS_REGISTRATION_ENABLED = "true";
          IS_DASHBOARD_ENABLED = "true";
          CONNECT_WITH_FRANZ = "false";
          MAIL_CONNECTION = "smtp";
          SMTP_HOST = "127.0.0.1";
          SMTP_PORT = "2525";
          MAIL_SSL = "false";
          MAIL_USERNAME = "username";
          MAIL_SENDER = "noreply@ferdium.org";
        };
        environmentFiles = ["/var/lib/secrets/ferdium.env"];
      };
    };
  };
}
