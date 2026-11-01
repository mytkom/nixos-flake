# Personal NixOS configs

Single flake (`nixos-unstable` + Home Manager + nixos-hardware) for `x86_64-linux`. Formatter: `alejandra`.

## Hosts

| Host | Type | Hardware | Configs |
| --- | --- | --- | --- |
| levicorpus | laptop | ThinkPad T495, R5 3500U, 24GB RAM | NixOS + Home Manager |
| old-bunny | PC | i5-4460, GTX 960, 32GB RAM | NixOS + Home Manager |
| esprimo | home lab server | Fujitsu Esprimo Q556, i7-6700T, 16GB RAM | NixOS |
| AIC0189 (`aic`) | work laptop | - | Home Manager only |

## Usage

```sh
# NixOS
sudo nixos-rebuild switch --flake .#<host>

# Home Manager (standalone)
home-manager switch --flake .#mytkom@<host>
home-manager switch --flake .#m.mytkowski@AIC0189
```

## Layout

- `flake.nix` / `flake.lock` - inputs and outputs (lock file version 7)
- `hosts/<name>/` - per-machine `configuration.nix`, hardware config and `home.nix`
- `modules/nixos/` - blocked-hosts, esprimo-mount, gnome, tailscale
- `modules/home-manager/` - alacritty, common-apps, dconf, git, idasen, nvim (`nvim/init.lua`), zsh, hyprland (waybar, wallpaper)
- `overlays/` - nixpkgs overlays
- `pkgs/` - custom packages (e.g. `alibuild`)
