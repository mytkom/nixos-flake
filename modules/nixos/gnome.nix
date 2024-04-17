 { pkgs, ... }:
{
  # Xserver
  services.xserver = {
    enable = true;
    xkb.layout = "pl";
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverrides = ''
      [org.gnome.desktop.input-sources]
      xkb-options=['caps:escape']
      '';
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
  };
}
