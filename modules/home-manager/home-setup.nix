{ pkgs, ... }:
{
  home = {
    username = "mytkom";
    homeDirectory = "/home/mytkom";
    sessionVariables = {
      SHELL="${pkgs.zsh}/bin/zsh";
    };
  };
}
