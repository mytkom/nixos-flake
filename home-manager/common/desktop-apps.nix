{ pkgs, ... }: {
  home.packages = with pkgs; [
      brave
      obsidian
      dbeaver
      spotify
      discord
      google-chrome
      grimblast
      caprine-bin
      insomnia
      prismlauncher
      jetbrains.clion
      mplayer
      libreoffice
  ];
}
