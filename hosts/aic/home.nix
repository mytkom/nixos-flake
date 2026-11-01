# Work laptop (non-NixOS): standalone Home Manager only.
{inputs, ...}: {
  imports = with inputs.self.homeManagerModules; [
    zsh
    nvim
  ];

  home = {
    username = "m.mytkowski";
    homeDirectory = "/home/m.mytkowski@aiclearing.com";
  };

  targets.genericLinux.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
