{
  lib,
  config,
  vars,
  ...
}: {
  options.my.syncthing.enable = lib.mkEnableOption "Syncthing for the main user";

  config = lib.mkIf config.my.syncthing.enable {
    services.syncthing = {
      enable = true;
      user = vars.user;
      group = "users";
      dataDir = "/home/${vars.user}";
    };
  };
}
