# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = let
      # Helper function to inject -O3 safely into a package
      withO3 = pkg: pkg.overrideAttrs (oldAttrs: {
        env = (oldAttrs.env or {}) // {
          NIX_CFLAGS_COMPILE = (oldAttrs.env.NIX_CFLAGS_COMPILE or "") + " -O3";
        };
      });
    in
      final: prev: {
      # ffmpeg = withO3 prev.ffmpeg;
      # libjpeg = withO3 prev.libjpeg;
      # libpng = withO3 prev.libpng;
      # openblas = withO3 prev.openblas;

        # 2. Compression (Speeds up system updates and IO)
      #zstd = withO3 prev.zstd;
      #xz = withO3 prev.xz;
      #gzip = withO3 prev.gzip;

        # 4. Core System Tools (High usage binaries)
      #bash = withO3 prev.bash;
      #coreutils = withO3 prev.coreutils;
      #gnugrep = withO3 prev.gnugrep;
      };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
