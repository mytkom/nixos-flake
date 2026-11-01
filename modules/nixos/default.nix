# Personal NixOS modules. Option-based ones are inert until enabled via `my.<name>.enable`.
{
  common = import ./common.nix;
  ssh = import ./ssh.nix;
  dev = import ./dev.nix;
  syncthing = import ./syncthing.nix;
  gnome = import ./gnome.nix;
  audio = import ./audio.nix;
  printing = import ./printing.nix;
  laptop-power = import ./laptop-power.nix;
  blocked-hosts = import ./blocked-hosts.nix;
  tailscale = import ./tailscale.nix;
  esprimo-mount = import ./esprimo-mount.nix;
}
