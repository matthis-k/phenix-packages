{ lib }:
pkgs:
{
  name,
  repository,
  storePath,
  run,
  developmentPath ? ".",
  runtimeInputs ? [ ],
  meta ? { },
}:
assert lib.assertMsg (name != "") "mkPhenixWrapper: name must not be empty";
assert lib.assertMsg (repository != "") "mkPhenixWrapper: repository must not be empty";
assert lib.assertMsg (developmentPath != "") "mkPhenixWrapper: developmentPath must not be empty";
pkgs.writeShellApplication {
  inherit name runtimeInputs meta;

  text = ''
    phenix_dev="''${PHENIX_DEV:-0}"

    case "$phenix_dev" in
      ""|0|false|FALSE|no|NO|off|OFF)
        export PHENIX_MODE=store
        export PHENIX_SOURCE_ROOT=${lib.escapeShellArg (toString storePath)}
        ;;

      1|true|TRUE|yes|YES|on|ON)
        : "''${HOME:?HOME must be set when PHENIX_DEV is enabled}"

        export PHENIX_MODE=dev
        export PHENIX_ROOT="''${PHENIX_ROOT:-$HOME/phenix}"
        export PHENIX_REPOS_DIR="$PHENIX_ROOT/repos"

        repository=${lib.escapeShellArg repository}
        development_path=${lib.escapeShellArg developmentPath}
        export PHENIX_REPO_ROOT="$PHENIX_REPOS_DIR/$repository"

        if [[ ! -d "$PHENIX_REPOS_DIR" ]]; then
          printf 'Phenix development workspace is not initialized: %s\n' "$PHENIX_REPOS_DIR" >&2
          exit 66
        fi

        if [[ ! -d "$PHENIX_REPO_ROOT" ]]; then
          printf 'Phenix repository is missing from the workspace: %s\n' "$PHENIX_REPO_ROOT" >&2
          exit 66
        fi

        if [[ "$development_path" == "." ]]; then
          export PHENIX_SOURCE_ROOT="$PHENIX_REPO_ROOT"
        else
          export PHENIX_SOURCE_ROOT="$PHENIX_REPO_ROOT/$development_path"
        fi

        if [[ ! -e "$PHENIX_SOURCE_ROOT" ]]; then
          printf 'Phenix development source does not exist: %s\n' "$PHENIX_SOURCE_ROOT" >&2
          exit 66
        fi
        ;;

      *)
        printf 'Invalid PHENIX_DEV value: %s (expected 0/1, false/true, no/yes, or off/on)\n' "$phenix_dev" >&2
        exit 64
        ;;
    esac

    ${run}
  '';
}
