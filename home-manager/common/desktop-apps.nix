{ pkgs, ... }: {
  home.packages = with pkgs; [
      brave
      obsidian
      spotify
      discord
  ];
}
