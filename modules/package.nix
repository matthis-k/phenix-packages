{ inputs, ... }:
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
    { pkgs, system, ... }:
    {
      inherit ((import ../packages/dev-tools.nix { inherit pkgs; })) packages;

      devShells.default = pkgs.mkShell {
        name = "phenix-packages-dev";
        packages = with pkgs; [
          nix
          nixfmt
          statix
          deadnix
          inputs.phenix-tend.packages.${system}.tend
        ];
        shellHook = ''
          repo-hook() {
            tend check --profile git-hook --context local "$@"
          }
          repo-pushgate() {
            tend check --profile pre-push --context local "$@"
          }
          repo-check() {
            tend check --profile manual --context local "$@"
          }
          repo-fix() {
            tend check --profile fix --context local "$@"
          }
          export -f repo-hook repo-pushgate repo-check repo-fix 2>/dev/null || true

          echo "phenix-packages dev shell"
          echo "  tools: nix nixfmt statix deadnix tend"
          echo "  repo-hook      -> tend check --profile git-hook --context local"
          echo "  repo-pushgate  -> tend check --profile pre-push --context local"
          echo "  repo-check     -> tend check --profile manual --context local"
          echo "  repo-fix       -> tend check --profile fix --context local"
        '';
      };
    };
}
