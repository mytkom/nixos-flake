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
    alacritty
    nvim
    home-setup
    git
    common-apps
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

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
