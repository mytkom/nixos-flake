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
    common-pc-laptop-ssd
    lenovo-thinkpad-t495

    inputs.self.nixosModules.gnome
    inputs.self.nixosModules.blocked-hosts
    inputs.self.nixosModules.tailscale

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

  # Enable OpenGL
  hardware.graphics.enable = true;


  boot = {
    loader.systemd-boot.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ ];
  };

  networking = {
    networkmanager = {
      enable = true;
      # ensureProfiles.profiles.uw-vpn = {
      #   connection = {
      #     id = "UW VPN";
      #     type = "vpn";
      #     autoconnect = "false";
      #   };
      #   vpn = {
      #     service-type = "org.freedesktop.NetworkManager.openconnect";
      #     gateway = "vpn.uw.edu.pl";
      #     protocol = "gp";
      #   };
      #   ipv4.method = "auto";
      #   ipv6.method = "auto";
      # };
    };
    hostName = "levicorpus";
    # wg-quick.interfaces.proton = {
    #   autostart = true;
    #   configFile = "/home/mytkom/nixos-flake/proton.conf";
    # };
  };

  # CLI fallback for GlobalProtect SSO (browser-based SAML)
  environment.systemPackages = with pkgs; [
    openconnect
    gpclient
  ];

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
  services.pulseaudio.enable = false;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
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

  # For some reason needed for printing
  services.samba = {
    enable = true;
    settings = {
      "global" = {
        workgroup = "WORKGROUP";
        "client min protocol" = "NT1";
        "client max protocol" = "SMB3";
        security = "user";
      };
    };
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

  services.syncthing = {
    enable = true;
    user = "mytkom";
    group = "users";
    dataDir = "/home/mytkom";
  };

  # Battery life
  services = {
    system76-scheduler.settings.cfsProfiles.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "performance";
        STOP_CHARGE_THRESH_BAT1 = "95";
        CPU_MAX_PERF_ON_AC = "100";
        CPU_MAX_PERF_ON_BAT = "90";
        AHCI_RUNTIME_PM_ON_BAT="on";
        # RUNTIME_PM_DRIVER_DENYLIST="mei_me nouveau radeon ahci";
        # USB_DENYLIST="1d6b:0002 1d6b:0003 13fe:4300";
        # RUNTIME_PM_DENYLIST="05:00.3 05:00.4";
      };
    };
    logind.killUserProcesses = true;
    power-profiles-daemon.enable = false;
  };
  powerManagement.powertop.enable = false;

  # Udev
  services.udev.extraRules = ''
    RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/amdgpu_bl0/brightness"
    RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/amdgpu_bl0/brightness"
  '';

  # services.fwupd.enable = true;

  # NerdFonts picking
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];

  # Xserver
  services.xserver = {
    videoDrivers = ["amdgpu"];
  };

  services.libinput.enable = true;

  programs.dconf.enable = true;
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  # Nix-ld
  programs.nix-ld.enable = true;

  # Programs
  virtualisation.docker.enable = true;
  programs.singularity.enable = true;
  programs.zsh.enable = true;
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # Users
  users.users = {
    mytkom = {
      initialPassword = "12345678";
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = ["wheel" "tty" "video" "audio" "docker" "input"];
    };
  };
  users.defaultUserShell = pkgs.zsh;



  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
