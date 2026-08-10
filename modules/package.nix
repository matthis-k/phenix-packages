_:
let
  homeModules = {
    devTools = import ./home/dev-tools.nix;
  };
in
{
  flake = {
    inherit homeModules;
  };

  perSystem =
    { pkgs, ... }:
    let
      devTools = import ../packages/dev-tools.nix { inherit pkgs; };
    in
    {
      inherit (devTools) packages;

      checks.dev-tools = pkgs.linkFarm "phenix-dev-tools-check" (
        pkgs.lib.mapAttrsToList (name: path: { inherit name path; }) devTools.packages
      );
    };
}
