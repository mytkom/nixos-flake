# Overlays applied to every NixOS host and Home Manager config (see flake.nix).
_: {
  # Brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final;

  # Version overrides, patches, compilation flags, etc.
  # https://nixos.wiki/wiki/Overlays
  modifications = _final: _prev: {
    # example = prev.example.overrideAttrs (old: { ... });
  };
}
