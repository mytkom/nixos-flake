# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-laptop-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
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
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Hardware
  hardware = {
    opengl.enable = true;
    pulseaudio.enable = false;
  };

  # Boot
  boot = {
    loader.systemd-boot.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ config.boot.kernelPackages.rtl8812au ];
  };

  # Network
  networking = {
    networkmanager.enable = true;
    hostName = "levicorpus";
  };

  # Locales
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  services.locate.enable = true;

  # Security
  security.rtkit.enable = true;
  security.polkit.enable = true;
  
  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      foomatic-db-nonfree
      foomatic-db-ppds-withNonfreeDb
      gutenprint
      cnijfilter2
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };

  hardware.printers = {
    ensurePrinters = [
    {
      name = "Canon3225(MINI)";
      location = "Uni";
      deviceUri = "smb://duodecimus.mini.pw.edu.pl/wirtualna";
      model = "foomatic-db-ppds/Canon-imageRunner_3225-pxlmono.ppd.gz";
      ppdOptions = {
        PageSize = "A4";
      };
    }
    ];
    ensureDefaultPrinter = "Canon3225(MINI)";
  };  

  # Udev
  services.udev.extraRules = ''
    RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/amdgpu_bl0/brightness" 
    RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/amdgpu_bl0/brightness" 
  '';

  # NerdFonts picking
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  # Xserver
  services.xserver = {
    enable = true;
    videoDrivers = ["amdgpu"];
    desktopManager.gnome = {
      enable = true;
    };
    displayManager.gdm = {
      enable = true;
    };
  };

  # Gnome
  environment = {
    systemPackages = with pkgs; [
      gnome.adwaita-icon-theme
      gnomeExtensions.appindicator
      gedit
      qemu
    ];
    gnome.excludePackages = (with pkgs; [
        gnome-photos
        gnome-tour
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gnome-terminal
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);
    etc = {
      "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '';
    };
  };
  programs.dconf.enable = true;
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

#  # Hyprland
#  programs.hyprland = {
#    enable = true;
#    xwayland.enable = true;
#  };

  # Nix-ld
  programs.nix-ld.enable = true;

#  # Xdg
#  xdg.portal = {
#    enable = true;
#    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
#  };

  # Programs
  virtualisation.docker.enable = true;
  programs.zsh.enable = true;

  # Users
  users.users = {
    mytkom = {
      initialPassword = "12345678";
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = ["wheel" "tty" "video" "audio" "docker"];
    };
  };
  users.defaultUserShell = pkgs.zsh;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
