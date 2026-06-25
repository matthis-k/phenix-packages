{
  description = "Phenix custom package overlays and derivations";

  inputs = {
    phenix-pins.url = "github:matthis-k/phenix-pins";
    nixpkgs.follows = "phenix-pins/nixpkgs";
  };

  outputs = inputs: {
    packages.x86_64-linux.default = (import inputs.nixpkgs {
      system = "x86_64-linux";
    }).hello;

    packages.aarch64-linux.default = (import inputs.nixpkgs {
      system = "aarch64-linux";
    }).hello;
  };
}
