{ config, pkgs, ... }:
let
  zoteroWrapped = pkgs.writeShellScriptBin "zotero" ''
    export LD_LIBRARY_PATH="${pkgs.gcc.cc.lib}/lib:$LD_LIBRARY_PATH"
    exec ${pkgs.zotero}/bin/zotero "$@"
  '';

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

  # Generate per-app shell scripts
  appScripts = builtins.listToAttrs (map (app: {
    name = "focus-or-launch-${app.name}";
    value = pkgs.writeShellScript "focus-or-launch-${app.name}" ''
      if ${pkgs.wmctrl}/bin/wmctrl -lx | grep -i ${app.wmClass}; then
          ${pkgs.wmctrl}/bin/wmctrl -xa ${app.wmClass}
      else
          ${app.command} &
      fi
    '';
  }) appShortcuts);

  # Create xdg config files pointing to the scripts
  scriptFiles = builtins.mapAttrs (name: file: {
    source = file;
  }) appScripts;

  # Create dconf entries
  customBindings = pkgs.lib.imap1 (i: app: "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString i}/") appShortcuts;

customKeybindings = builtins.listToAttrs (pkgs.lib.imap1 (i: app: {
  name = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString i}";
  value = {
    command = "${config.xdg.configHome}/focus-or-launch-${app.name}";
    binding = app.shortcut;
    name = app.name;
  };
}) appShortcuts);

in {
  home.packages = with pkgs; [
      brave
      igv
      samtools
      obsidian
      dbeaver-bin
      spotify
      discord
      gimp
      google-chrome
      grimblast
      caprine-bin
      insomnia
      prismlauncher
      mplayer
      libreoffice
      python3
      jetbrains.pycharm-professional
      python311Packages.pyzmq
      vscode-fhs
      keepassxc
      zoteroWrapped
      ferdium
      thunderbird
      wmctrl
  ];

   # Install generated scripts to ~/.config/
  xdg.configFile = scriptFiles;

  # Declarative GNOME keyboard shortcuts
dconf.settings = {
  "org/gnome/settings-daemon/plugins/media-keys" = {
    custom-keybindings = customBindings;
  };
} // customKeybindings;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
}

