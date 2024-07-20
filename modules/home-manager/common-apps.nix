{ pkgs, ... }: {
  home.packages = with pkgs; [
      brave
      igv
      samtools
      obsidian
      dbeaver
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
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
}
