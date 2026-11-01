{inputs, ...}: {
  imports = with inputs.self.homeManagerModules; [
    zsh
    alacritty
    nvim
    git
    common-apps
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
