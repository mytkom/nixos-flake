{ pkgs, ... }: {
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
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
}
