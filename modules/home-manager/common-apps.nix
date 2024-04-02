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

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
}
