{
  pkgs,
  lib,
  config,
  ...
}: {
  options.my.gnome.enable = lib.mkEnableOption "GNOME desktop with fonts and desktop basics";

  config = lib.mkIf config.my.gnome.enable {
    services.xserver = {
      enable = true;
      xkb.layout = "pl";
    };
    services.desktopManager.gnome = {
      enable = true;
      extraGSettingsOverrides = ''
        [org.gnome.desktop.input-sources]
        xkb-options=['caps:escape']
      '';
    };
    services.displayManager.gdm.enable = true;

    environment = {
      systemPackages = with pkgs; [
        adwaita-icon-theme
        gnomeExtensions.appindicator
        gnomeExtensions.x11-gestures
        touchegg
        gedit
        qemu
      ];
      gnome.excludePackages = with pkgs; [
        cheese
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
      ];
    };

    # Touchegg daemon for trackpad gestures
    services.touchegg.enable = true;

    security.rtkit.enable = true;
    security.polkit.enable = true;

    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
    ];
  };
}
