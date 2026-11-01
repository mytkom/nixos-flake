{
  description = "mytkom's Nix Config: flake-based, with home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Second nixpkgs pin used ONLY for claude-code, so it can be bumped alone:
    #   nix flake update nixpkgs-claude
    nixpkgs-claude.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    inherit (nixpkgs) lib;
    system = "x86_64-linux";
    forAllSystems = lib.genAttrs [system];

    # Values shared by NixOS hosts and Home Manager configs.
    vars = {
      user = "mytkom";
      nixpkgsConfig = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        cplex.releasePath = "/home/mytkom/Documents/ODA/cplex_studio2211.linux_x86_64.bin";
      };
    };

    mkHost = name:
      lib.nixosSystem {
        specialArgs = {inherit inputs outputs vars;};
        modules = builtins.attrValues outputs.nixosModules ++ [./hosts/${name}/configuration.nix];
      };

    mkHome = path:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {inherit inputs outputs vars;};
        modules = [outputs.homeManagerModules.base path];
      };
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forAllSystems (system: {
      default = nixpkgs.legacyPackages.${system}.mkShell {
        packages = with nixpkgs.legacyPackages.${system}; [alejandra statix deadnix];
      };
    });

    # `nix flake check` verifies formatting (and evaluates all outputs).
    checks = forAllSystems (system: {
      formatting = nixpkgs.legacyPackages.${system}.runCommand "check-formatting" {} ''
        ${nixpkgs.legacyPackages.${system}.alejandra}/bin/alejandra --check ${self} && touch $out
      '';
    });

    overlays = import ./overlays {inherit inputs;};
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations = lib.genAttrs ["old-bunny" "levicorpus" "esprimo"] mkHost;

    homeConfigurations = {
      "mytkom@old-bunny" = mkHome ./hosts/old-bunny/home.nix;
      "mytkom@levicorpus" = mkHome ./hosts/levicorpus/home.nix;
      "mytkom@esprimo" = mkHome ./hosts/esprimo/home.nix;
      "m.mytkowski@AIC0189" = mkHome ./hosts/aic/home.nix;
    };
  };
}
