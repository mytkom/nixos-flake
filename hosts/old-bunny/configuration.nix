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
    inputs.self.nixosModules.blocked-hosts
    inputs.self.nixosModules.tailscale
    inputs.self.nixosModules.esprimo-mount

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
      cplex.releasePath = "/home/mytkom/Documents/ODA/cplex_studio2211.linux_x86_64.bin";
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

  services.xserver.displayManager.gdm.wayland = false;

  environment = {
    systemPackages = [ pkgs.qemu ];
  };

  # Enable OpenGL
  hardware.graphics.enable = true;

  hardware.nvidia-container-toolkit.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = false;
    nvidiaSettings = true;
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.KbdInteractiveAuthentication = true;
    settings.PermitRootLogin = "yes";
  };

  services.syncthing = {
    enable = true;
    user = "mytkom";
    group = "users";
    dataDir = "/home/mytkom";
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.enableAllFirmware = true;
  boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.kernelModules = [ "88x2bu" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl88x2bu
  ];
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.pulseaudio.enable = false;

  # NerdFonts picking
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
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
