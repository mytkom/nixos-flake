{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = with inputs.hardware.nixosModules; [
    common-cpu-intel
    common-pc-ssd

    inputs.self.nixosModules.gnome

    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
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


  environment = {
    systemPackages = [ pkgs.qemu ];
  };

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [ config.boot.kernelPackages.rtl88x2bu ];
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  sound.enable = true;
  security.rtkit.enable = true;
  security.polkit.enable = true;
  hardware.pulseaudio.enable = true;

  # NerdFonts picking
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  services.locate.enable = true;

  virtualisation.docker.enable = true;

  networking.hostName = "old-bunny";


  boot.loader = {
    systemd-boot = {
      enable = true;
    };
  };

  programs.nix-ld.enable = true;

  users.users = {
    mytkom = {
      initialPassword = "12345678";
      isNormalUser = true;
      extraGroups = ["wheel" "tty" "video" "audio" "docker"];
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
