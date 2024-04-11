{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = with inputs.hardware.nixosModules; [
    common-cpu-amd
    common-gpu-amd
    common-pc-laptop
    common-pc-laptop-ssd

    inputs.self.nixosModules.gnome

    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = with outputs.overlays; [
      additions
      modifications
      unstable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };

  nix = {
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    opengl.enable = true;
    pulseaudio.enable = false;
  };

  boot = {
    loader.systemd-boot.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ config.boot.kernelPackages.rtl8812au ];
  };

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
    nssmdns4 = true;
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

  # Battery life
  services = {
    system76-scheduler.settings.cfsProfiles.enable = true;
    tlp = {
      enable = true;
      settings = {
        PCIE_ASPM_ON_BAT = "powersupersave";
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        STOP_CHARGE_THRESH_BAT1 = "95";
        CPU_MAX_PERF_ON_AC = "100";
        CPU_MAX_PERF_ON_BAT = "30";
      };
    };
    logind.killUserProcesses = true;
    power-profiles-daemon.enable = false;
  };
  powerManagement.powertop.enable = true;

  # Udev
  services.udev.extraRules = ''
    RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/amdgpu_bl0/brightness"
    RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/amdgpu_bl0/brightness"
  '';

  # NerdFonts picking
  fonts.packages = with pkgs; [
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

  # Nix-ld
  programs.nix-ld.enable = true;

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
