{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vim
    wget
    btop
    tldr
    git
    neofetch
    fzf
    font-awesome
    findutils
    eza
    go
    idasen
    oh-my-zsh
    gh
    zellij
    zsh-powerlevel10k
  ];

  programs.zsh = {
    enable = true;
    shellAliases = {
      ls = "exa --icons";
      vim = "nvim";
      vi = "nvim";
      dcu = "docker compose up -d";
      dcb = "docker compose build";
      dcd = "docker compose down";
      dce = "docker compose exec";
      obsidian-clean-GPUcache = "rm -rf ~/.config/obsidian/GPUCache/";
    };
    enableAutosuggestions = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
       "git"
      ];
    };
    initExtra = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
    '';
  };
}
