{ pkgs, ... }: {
  home.packages = with pkgs; [
      brave
      igv
      samtools
      obsidian
      dbeaver
      spotify
      discord
      google-chrome
      grimblast
      caprine-bin
      insomnia
      prismlauncher
      mplayer
      libreoffice
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
}
