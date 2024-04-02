{
  # List your module files here
  dconf = import ./dconf.nix;
  idasen = import ./idasen.nix;
  git = import ./git.nix;
  home-setup = import ./home-setup.nix;
  zsh = import ./zsh.nix;
  alacritty = import ./alacritty.nix;
  nvim = import ./nvim.nix;
  common-apps = import ./common-apps.nix;
  hyprland = import ./hyprland;
}
