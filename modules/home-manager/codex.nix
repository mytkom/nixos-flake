# OpenAI Codex CLI, pinned by the separate `nixpkgs-codex` flake input.
# Update only this tool with: nix flake update nixpkgs-codex
{
  inputs,
  pkgs,
  vars,
  ...
}: {
  programs.codex = {
    enable = true;
    package =
      (import inputs.nixpkgs-codex {
        inherit (pkgs.stdenv.hostPlatform) system;
        config = vars.nixpkgsConfig;
      }).codex;
  };
}
