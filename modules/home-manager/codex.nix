# OpenAI Codex CLI, pinned by the separate `nixpkgs-codex` flake input.
# Update only this tool with: nix flake update nixpkgs-codex
{
  inputs,
  pkgs,
  vars,
  ...
}: let
  codexPkgs = import inputs.nixpkgs-codex {
    inherit (pkgs.stdenv.hostPlatform) system;
    config = vars.nixpkgsConfig;
  };
in {
  programs.codex = {
    enable = true;
    package = codexPkgs.codex;
  };

  # Codex's Linux sandbox looks up `bwrap` on PATH.
  home.packages = [codexPkgs.bubblewrap];
}
