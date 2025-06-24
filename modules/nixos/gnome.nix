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
      adwaita-icon-theme
      gnomeExtensions.appindicator
      gnomeExtensions.x11-gestures
      touchegg
      gedit
      qemu
    ];
    gnome.excludePackages = (with pkgs; [
        cheese
        gnome-photos
        gnome-tour
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
  # Set up the Touchegg daemon for trackpad gestures
  services.touchegg = {
    enable = true;
  };
}
