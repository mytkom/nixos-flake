{
  lib,
  config,
  ...
}: {
  options.my.tailscale.enable = lib.mkEnableOption "Tailscale";

  config = lib.mkIf config.my.tailscale.enable {
    services.tailscale.enable = true;
  };
}
