{pkgs, ...}: let
  zoteroWrapped = pkgs.writeShellScriptBin "zotero" ''
    export LD_LIBRARY_PATH="${pkgs.gcc.cc.lib}/lib:$LD_LIBRARY_PATH"
    exec ${pkgs.zotero}/bin/zotero "$@"
  '';
in {
  imports = [./app-shortcuts.nix];

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
    jetbrains.pycharm
    python3Packages.pyzmq
    vscode-fhs
    keepassxc
    zoteroWrapped
    ferdium
    thunderbird
    anki
    eduvpn-client
    ocenaudio
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
    # Zotero 10.x builds against this Firefox ESR
    "firefox-esr-140-bin-unwrapped-140.17.0esr"
  ];
}
