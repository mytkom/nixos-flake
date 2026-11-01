{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = with inputs.hardware.nixosModules; [
    common-cpu-intel
    common-pc-ssd

    ./hardware-configuration.nix
  ];

  networking.hostName = "old-bunny";

  my = {
    gnome.enable = true;
    blockedHosts.enable = true;
    tailscale.enable = true;
    esprimoMount.enable = true;
    dev.enable = true;
    ssh = {
      enable = true;
      # TODO: switch to key-only auth once authorizedKeys are set for mytkom.
      passwordAuthentication = true;
    };
  };

  boot = {
    loader.systemd-boot.enable = true;
    kernelPackages = pkgs.linuxPackages_6_12;
    kernelModules = ["88x2bu"];
    extraModulePackages = with config.boot.kernelPackages; [rtl88x2bu];
  };

  environment.systemPackages = [pkgs.qemu];

  # NVIDIA
  services.xserver.videoDrivers = ["nvidia"];
  hardware = {
    graphics.enable = true;
    nvidia-container-toolkit.enable = true;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      open = false;
      nvidiaSettings = true;
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    enableAllFirmware = true;
  };

  services.syncthing = {
    enable = true;
    user = "mytkom";
    group = "users";
    dataDir = "/home/mytkom";
  };

  users.users.mytkom = {
    isNormalUser = true;
    extraGroups = ["wheel" "tty" "video" "audio" "docker"];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
