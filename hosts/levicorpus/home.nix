{inputs, ...}: {
  imports = with inputs.self.homeManagerModules; [
    dconf
    idasen
    git
    zsh
    alacritty
    nvim
    claude-code
    common-apps
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
