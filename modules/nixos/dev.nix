{
  lib,
  config,
  ...
}: {
  options.my.dev.enable = lib.mkEnableOption "development basics (docker, nix-ld)";

  config = lib.mkIf config.my.dev.enable {
    virtualisation.docker.enable = true;
    programs.nix-ld.enable = true;
  };
}
