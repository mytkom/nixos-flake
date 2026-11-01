{inputs, ...}: {
  imports = with inputs.self.homeManagerModules; [
    zsh
    nvim
    git
    claude-code
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
