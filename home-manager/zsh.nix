{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
    	ls = "exa --icons";
	    vim = "nvim";
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
