{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = with inputs.self.homeManagerModules; [
    zsh
    nvim
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "m.mytkowski";
    homeDirectory = "/home/m.mytkowski@aiclearing.com";
    sessionVariables = {
      SHELL="${pkgs.zsh}/bin/zsh";
    };
  };

  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
