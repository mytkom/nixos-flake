# GNOME shortcuts that cycle an app's windows (round-robin) or launch it when
# none is open, via the Run or Raise extension (works on Wayland, unlike wmctrl).
{
  pkgs,
  lib,
  ...
}: let
  # wm_class is case-sensitive; regexes (between slashes) keep it tolerant.
  appShortcuts = [
    {
      shortcut = "<Super>q";
      command = "alacritty";
      wmClass = "/[Aa]lacritty/";
    }
    {
      shortcut = "<Super>f";
      command = "ferdium";
      wmClass = "/[Ff]erdium/";
    }
    {
      shortcut = "<Super>z";
      command = "zotero";
      wmClass = "/[Zz]otero/";
    }
    {
      shortcut = "<Super>e";
      command = "thunderbird";
      wmClass = "/[Tt]hunderbird/";
    }
    {
      shortcut = "<Super>b";
      command = "google-chrome-stable";
      wmClass = "/[Gg]oogle-chrome/";
    }
  ];

  shortcutsConf = lib.concatMapStringsSep "\n" (
    app: "${app.shortcut},${app.command},${app.wmClass},"
  )
  appShortcuts;
in {
  home.packages = [pkgs.gnomeExtensions.run-or-raise];

  xdg.configFile."run-or-raise/shortcuts.conf".text = shortcutsConf + "\n";

  dconf.settings = {
    "org/gnome/shell".enabled-extensions = [
      "run-or-raise@edvard.cz"
      "appindicatorsupport@rgcjonas.gmail.com"
    ];
    # Drop the old wmctrl-based custom keybindings.
    "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [];
  };
}
