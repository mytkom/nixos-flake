# Claude Code CLI, pinned by the separate `nixpkgs-claude` flake input.
# Update only this tool with: nix flake update nixpkgs-claude
{
  inputs,
  pkgs,
  vars,
  ...
}: {
  programs.claude-code = {
    enable = true;
    package =
      (import inputs.nixpkgs-claude {
        inherit (pkgs.stdenv.hostPlatform) system;
        config = vars.nixpkgsConfig;
      }).claude-code;
  };
}
