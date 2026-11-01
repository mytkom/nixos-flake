{
  base = import ./base.nix;
  dconf = import ./dconf.nix;
  idasen = import ./idasen.nix;
  git = import ./git.nix;
  zsh = import ./zsh.nix;
  alacritty = import ./alacritty.nix;
  nvim = import ./nvim.nix;
  common-apps = import ./common-apps.nix;
  app-shortcuts = import ./app-shortcuts.nix;
  claude-code = import ./claude-code.nix;
  hyprland = import ./hyprland;
}
