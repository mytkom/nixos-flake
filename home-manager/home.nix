# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./zsh.nix
    ./alacritty.nix
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
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

  # Add stuff for your user as you see fit:
  programs.neovim.enable = true;
  xdg.configFile.nvim.source = ./neovim-config;

  home.packages = with pkgs; [
    	waybar
    	dunst
    	swaybg
    	alacritty
    	rofi-wayland
    	libnotify
    	networkmanagerapplet    

    	# desktop
    	brave
    	obsidian
    	spotify
    	discord

    	# cli
    	vim
    	wget
    	btop
    	tldr
    	git
    	neofetch
    	fzf
    	font-awesome
    	findutils
    	exa
    	go
    	idasen
    	oh-my-zsh
    	gh
	    nix-ld
	    gcc9
	    pkgconfig
	    zellij
      libxkbcommon
      wayland

      # oh-my-zsh
      zsh-powerlevel10k
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
  home.stateVersion = "23.05";
}
