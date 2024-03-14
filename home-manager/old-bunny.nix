{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./common/zsh.nix
    ./common/alacritty.nix
    ./common/nvim
    ./common/desktop-apps.nix
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
    username = "mytkom";
    homeDirectory = "/home/mytkom";
    shell = pkgs.zsh;
    sessionVariables = {
      SHELL="${pkgs.zsh}/bin/zsh";
      CGO_CFLAGS="-I${inputs.nixpkgs-stable.legacyPackages.x86_64-linux.csfml}/include";
      CGO_LDFLAGS="-L${inputs.nixpkgs-stable.legacyPackages.x86_64-linux.csfml}/lib/gcc";
    };
  };

  home.packages = with inputs.nixpkgs-stable.legacyPackages.x86_64-linux; [
      sfml
      csfml
      ];

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "mytkom";
    userEmail = "marek.mytkowski.mm@gmail.com";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
