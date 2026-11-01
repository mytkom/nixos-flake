# Personal NixOS configs

Single flake (`nixos-unstable` + Home Manager + nixos-hardware) for `x86_64-linux`. Formatter: `alejandra`.

## Hosts

| Host | Type | Hardware | Configs |
| --- | --- | --- | --- |
| levicorpus | laptop | ThinkPad T495, R5 3500U, 24GB RAM | NixOS + Home Manager |
| old-bunny | PC | i5-4460, GTX 960, 32GB RAM | NixOS + Home Manager |
| esprimo | headless home lab server (SSH only) | Fujitsu Esprimo Q556, i7-6700T, 16GB RAM | NixOS with integrated Home Manager |
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

- `flake.nix` / `flake.lock` - inputs and outputs; `mkHost` / `mkHome` build every config, `vars` holds shared values
- `hosts/<name>/` - per-machine `configuration.nix`, hardware config and `home.nix`
- `modules/nixos/` - `common` (applied to every host) plus option-gated modules enabled per host via `my.<name>.enable`: `ssh`, `dev`, `gnome`, `audio`, `printing`, `laptop-power`, `blocked-hosts`, `tailscale`, `esprimo-mount`, `selfhosted`, `econ-ingest`
- `modules/home-manager/` - `base` (applied to every home) plus modules imported per host: alacritty, common-apps, app-shortcuts, dconf, git, idasen, nvim (`nvim/init.lua`), zsh, hyprland (waybar + `waybar.css`)
- `overlays/` - nixpkgs overlays (applied everywhere)
- `pkgs/` - custom packages (e.g. `alibuild`)

## Development

```sh
nix develop      # alejandra, statix, deadnix
nix fmt          # format
nix flake check  # evaluates all outputs, checks formatting
```

## Claude Code

Installed through the `claude-code` Home Manager module from a dedicated `nixpkgs-claude` input, so it updates independently of the rest of the system:

```sh
nix flake update nixpkgs-claude   # bump Claude Code only
home-manager switch --flake .#mytkom@<host>   # not needed on esprimo
```
