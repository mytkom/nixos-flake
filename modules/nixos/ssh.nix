{
  lib,
  config,
  ...
}: let
  cfg = config.my.ssh;
in {
  options.my.ssh = {
    enable = lib.mkEnableOption "OpenSSH server";
    passwordAuthentication = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Allow password logins. Prefer keys (users.users.<name>.openssh.authorizedKeys).";
    };
    permitRootLogin = lib.mkOption {
      type = lib.types.str;
      default = "no";
      description = "Value for sshd PermitRootLogin.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = cfg.passwordAuthentication;
        KbdInteractiveAuthentication = cfg.passwordAuthentication;
        PermitRootLogin = cfg.permitRootLogin;
      };
    };
  };
}
