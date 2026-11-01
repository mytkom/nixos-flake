# Applied to every Home Manager config (see mkHome in flake.nix).
{
  pkgs,
  lib,
  vars,
  outputs,
  ...
}: {
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = vars.nixpkgsConfig;
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home = {
    username = lib.mkDefault vars.user;
    homeDirectory = lib.mkDefault "/home/${vars.user}";
    sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";
  };
}
