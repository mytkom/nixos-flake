# GNOME keyboard shortcuts that focus an app's window or launch it.
{
  config,
  pkgs,
  lib,
  ...
}: let
  appShortcuts = [
    {
      name = "Ferdium";
      wmClass = "ferdium";
      command = "ferdium";
      shortcut = "<Super>f";
    }
    {
      name = "Zotero";
      wmClass = "zotero";
      command = "zotero";
      shortcut = "<Super>z";
    }
    {
      name = "Thunderbird";
      wmClass = "thunderbird";
      command = "thunderbird";
      shortcut = "<Super>e";
    }
    {
      name = "Chrome";
      wmClass = "chrome";
      command = "google-chrome-stable";
      shortcut = "<Super>b";
    }
  ];

  # Per-app focus-or-launch scripts, installed to ~/.config/
  scriptFiles = builtins.listToAttrs (map (app: {
      name = "focus-or-launch-${app.name}";
      value.source = pkgs.writeShellScript "focus-or-launch-${app.name}" ''
        if ${pkgs.wmctrl}/bin/wmctrl -lx | grep -i ${app.wmClass}; then
            ${pkgs.wmctrl}/bin/wmctrl -xa ${app.wmClass}
        else
            ${app.command} &
        fi
      '';
    })
    appShortcuts);

  bindingPath = i: "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString i}";

  customKeybindings = builtins.listToAttrs (lib.imap1 (i: app: {
      name = bindingPath i;
      value = {
        command = "${config.xdg.configHome}/focus-or-launch-${app.name}";
        binding = app.shortcut;
        inherit (app) name;
      };
    })
    appShortcuts);
in {
  home.packages = [pkgs.wmctrl];

  xdg.configFile = scriptFiles;

  dconf.settings =
    {
      "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings =
        lib.imap1 (i: _: "/${bindingPath i}/") appShortcuts;
    }
    // customKeybindings;
}
