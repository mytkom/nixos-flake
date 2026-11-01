# Applied to every NixOS host (see mkHost in flake.nix).
{
  inputs,
  outputs,
  vars,
  lib,
  config,
  ...
}: {
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = vars.nixpkgsConfig;
  };

  nix = {
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    settings = {
      nix-path = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  networking.networkmanager.enable = true;
  services.locate.enable = true;
}
