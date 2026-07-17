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
    {
      inherit ((import ../packages/dev-tools.nix { inherit pkgs; })) packages;

      devShells.default = pkgs.mkShell {
        name = "phenix-packages-dev";
        packages = with pkgs; [
          devenv
          git
          nix
        ];
        shellHook = ''
          echo "phenix-packages dev shell"
          echo "  maintenance: devenv test"
          echo "  fixes:       devenv tasks run maintenance:fix"
        '';
      };
    };
}
