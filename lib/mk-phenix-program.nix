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
  storeName ? "${name}-store",
  developmentName ? "${name}-dev",
}:
assert lib.assertMsg (name != "") "mkPhenixProgram: name must not be empty";
assert lib.assertMsg (repository != "") "mkPhenixProgram: repository must not be empty";
assert lib.assertMsg (developmentPath != "") "mkPhenixProgram: developmentPath must not be empty";
assert lib.assertMsg (storeName != "") "mkPhenixProgram: storeName must not be empty";
assert lib.assertMsg (developmentName != "") "mkPhenixProgram: developmentName must not be empty";
assert lib.assertMsg (
  name != storeName
) "mkPhenixProgram: wrapper and store program names must differ";
assert lib.assertMsg (
  name != developmentName
) "mkPhenixProgram: wrapper and development program names must differ";
assert lib.assertMsg (
  storeName != developmentName
) "mkPhenixProgram: store and development program names must differ";
let
  commandMeta =
    commandName: (builtins.removeAttrs meta [ "mainProgram" ]) // { mainProgram = commandName; };

  store = pkgs.writeShellApplication {
    name = storeName;
    inherit runtimeInputs;
    meta = commandMeta storeName;
    text = ''
      export PHENIX_DEV=0
      export PHENIX_MODE=store
      export PHENIX_SOURCE_ROOT=${lib.escapeShellArg (toString storePath)}

      ${run}
    '';
  };

  development = pkgs.writeShellApplication {
    name = developmentName;
    runtimeInputs = [ pkgs.coreutils ] ++ runtimeInputs;
    meta = commandMeta developmentName;
    text = ''
      : "''${HOME:?HOME must be set for a Phenix development program}"

      root="''${PHENIX_ROOT:-$HOME/phenix}"
      PHENIX_ROOT="$(realpath -m "$root")"
      export PHENIX_ROOT
      export PHENIX_DEV=1
      export PHENIX_MODE=dev
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

      ${run}
    '';
  };

  wrapper = pkgs.writeShellApplication {
    inherit name;
    meta = commandMeta name;
    text = ''
      case "''${PHENIX_DEV:-0}" in
        ""|0|false|FALSE|no|NO|off|OFF)
          exec ${lib.escapeShellArg "${store}/bin/${storeName}"} "$@"
          ;;

        1|true|TRUE|yes|YES|on|ON)
          exec ${lib.escapeShellArg "${development}/bin/${developmentName}"} "$@"
          ;;

        *)
          printf 'Invalid PHENIX_DEV value: %s (expected 0/1, false/true, no/yes, or off/on)\n' "$PHENIX_DEV" >&2
          exit 64
          ;;
      esac
    '';
  };
in
{
  inherit development store wrapper;
}
