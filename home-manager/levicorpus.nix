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
    sessionVariables = {
      SHELL="${pkgs.zsh}/bin/zsh";
    };
  };

  dconf.settings = {
    "org.gnome.desktop.input-sources" = {
      xkb-options = "['caps:escape']";
    };
    "org.gnome.mutter" = {
      experimental-features = "['scale-monitor-framebuffer']";
    };
  };

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "mytkom";
    userEmail = "marek.mytkowski.mm@gmail.com";
  };

  home.file.".config/idasen/idasen.yaml".text = ''
    mac_address: E3:02:D4:42:35:4F
    positions:
      sit: 0.81
      stand: 1.25
  '';

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
