{ pkgs, ... }:
let
  zoteroWrapped = pkgs.writeShellScriptBin "zotero" ''
    export LD_LIBRARY_PATH="${pkgs.gcc.cc.lib}/lib:$LD_LIBRARY_PATH"
    exec ${pkgs.zotero}/bin/zotero "$@"
  '';
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
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
}

