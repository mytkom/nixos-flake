{ pkgs, ... }:
{
  home.packages = with pkgs; [ alacritty ];

  programs.alacritty = {
    enable = true;
    settings = {
      shell.program = "${pkgs.zsh}/bin/zsh";
      startup.mode = "Windowed";
    };
  };
}
