{ lib, config, pkgs, ... }: {
  imports = [
    ./hyprland.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
      waybar
      dunst
      alacritty
      swaybg
      rofi-wayland
      libnotify
      networkmanagerapplet    
      kitty
      brillo
      foot
      pavucontrol
      libxkbcommon
      wayland
  ];
}
