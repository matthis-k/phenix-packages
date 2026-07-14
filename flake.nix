{
  description = "Shared Phenix development packages and Home Manager modules";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    phenix-pins.url = "github:matthis-k/phenix-pins";
    phenix-tend = {
      url = "github:matthis-k/phenix-tend";
      inputs = {
        phenix-pins.follows = "phenix-pins";
        flake-parts.follows = "flake-parts";
      };
    };
    nixpkgs.follows = "phenix-pins/nixpkgs";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      imports = [ ./modules/package.nix ];
      flake.flakeModules.default = import ./modules/flake-module.nix;
    };
}
