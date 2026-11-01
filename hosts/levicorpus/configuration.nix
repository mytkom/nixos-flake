{
  inputs,
  pkgs,
  ...
}: {
  imports = with inputs.hardware.nixosModules; [
    common-cpu-amd
    common-pc-laptop-ssd
    lenovo-thinkpad-t495

    ./hardware-configuration.nix
  ];

  networking.hostName = "levicorpus";

  my = {
    gnome.enable = true;
    blockedHosts.enable = true;
    tailscale.enable = true;
    dev.enable = true;
    syncthing.enable = true;
    audio.enable = true;
    printing.enable = true;
    laptopPower.enable = true;
  };

  # CLI fallback for GlobalProtect SSO (browser-based SAML)
  environment.systemPackages = with pkgs; [
    openconnect
    gpclient
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  hardware.graphics.enable = true;

  boot = {
    loader.systemd-boot.enable = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.xserver.videoDrivers = ["amdgpu"];
  services.libinput.enable = true;

  programs.dconf.enable = true;
  services.udev.packages = [pkgs.gnome-settings-daemon];

  programs.singularity.enable = true;
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.zsh.enable = true;

  users.users.mytkom = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "tty" "video" "audio" "docker" "input"];
  };
  users.defaultUserShell = pkgs.zsh;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
