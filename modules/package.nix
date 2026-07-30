{ inputs, ... }:
let
  homeModules = {
    devTools = import ./home/dev-tools.nix;
  };
  phenixLib = import ../lib { lib = inputs.nixpkgs.lib; };
in
{
  flake = {
    inherit homeModules;
    lib = phenixLib;
  };

  perSystem =
    { pkgs, ... }:
    let
      wrapperStore = pkgs.writeTextDir "config/value" "store\n";
      wrapperFixture = phenixLib.mkPhenixWrapper pkgs {
        name = "phenix-wrapper-fixture";
        repository = "phenix-example";
        storePath = "${wrapperStore}/config";
        developmentPath = "config";
        run = ''
          printf '%s:' "$PHENIX_MODE"
          cat "$PHENIX_SOURCE_ROOT/value"
        '';
      };
      wrapperCheck =
        pkgs.runCommand "phenix-runtime-wrapper-check"
          {
            nativeBuildInputs = [ wrapperFixture ];
          }
          ''
            export HOME="$TMPDIR/home"
            mkdir -p "$HOME"

            test "$(phenix-wrapper-fixture)" = "store:store"

            mkdir -p "$HOME/phenix/repos/phenix-example/config"
            printf 'development\n' > "$HOME/phenix/repos/phenix-example/config/value"
            test "$(PHENIX_DEV=1 phenix-wrapper-fixture)" = "dev:development"

            custom_root="$TMPDIR/custom-root"
            mkdir -p "$custom_root/repos/phenix-example/config"
            printf 'custom\n' > "$custom_root/repos/phenix-example/config/value"
            test "$(PHENIX_DEV=true PHENIX_ROOT="$custom_root" phenix-wrapper-fixture)" = "dev:custom"

            if PHENIX_DEV=invalid phenix-wrapper-fixture > invalid.log 2>&1; then
              echo "invalid PHENIX_DEV unexpectedly succeeded" >&2
              exit 1
            fi
            grep -q "Invalid PHENIX_DEV value" invalid.log

            if PHENIX_DEV=1 PHENIX_ROOT="$TMPDIR/missing" phenix-wrapper-fixture > missing.log 2>&1; then
              echo "missing workspace unexpectedly succeeded" >&2
              exit 1
            fi
            grep -q "workspace is not initialized" missing.log

            touch "$out"
          '';
    in
    {
      inherit ((import ../packages/dev-tools.nix { inherit pkgs; })) packages;

      checks.phenix-runtime-wrapper = wrapperCheck;

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
