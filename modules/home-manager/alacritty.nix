{ pkgs, ... }:
{
  home.packages = with pkgs; [ alacritty ];

  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell.program = "${pkgs.zsh}/bin/zsh";
      font.size = 13.0;
      window.startup_mode = "Windowed";
    };
  };
}
