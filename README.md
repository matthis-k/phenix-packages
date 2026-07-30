# phenix-packages

Shared development packages and Home Manager modules for the Phenix workspace.

## Packages

The flake exports the following packages under `packages.<system>.<name>`:

| Package | Description |
|---|---|
| git | Distributed version control system |
| gh | GitHub CLI |
| ripgrep | Line-oriented search tool |
| fd | Simple, fast alternative to `find` |
| fzf | Command-line fuzzy finder |
| bat | `cat` replacement with syntax highlighting |
| eza | Modern `ls` replacement |
| delta | Syntax-highlighting pager for Git |
| jq | Command-line JSON processor |
| htop | Interactive process viewer |
| btop | Resource monitor |
| tmux | Terminal multiplexer |
| lazygit | Terminal UI for Git |
| zoxide | Smarter directory navigation |
| curl | HTTP client |
| wget | Network downloader |
| unzip | ZIP archive extractor |
| starship | Shell prompt |

Run a package directly with:

```console
nix run github:matthis-k/phenix-packages#<name>
```

## Runtime wrappers

`lib.mkPhenixWrapper` creates one executable that resolves configuration or source data from either the Nix store or the local Phenix workspace.

```nix
let
  mkPhenixWrapper = inputs.phenix-packages.lib.mkPhenixWrapper pkgs;
in
mkPhenixWrapper {
  name = "example";
  repository = "phenix-example";
  storePath = packagedConfig;
  developmentPath = "config";
  runtimeInputs = [ executablePackage ];
  run = ''
    exec executable --config "$PHENIX_SOURCE_ROOT" "$@"
  '';
}
```

The wrapper has one mode switch:

| Variable | Meaning |
|---|---|
| `PHENIX_DEV=1` | Resolve from the local workspace. Truthy forms `true`, `yes`, and `on` are also accepted. |
| `PHENIX_ROOT` | Root checkout containing `repos/`; defaults to `$HOME/phenix` in development mode. |

Store mode is the default and sets `PHENIX_SOURCE_ROOT` to `storePath`. Development mode derives `<PHENIX_ROOT>/repos/<repository>/<developmentPath>` and exports `PHENIX_ROOT`, `PHENIX_REPOS_DIR`, `PHENIX_REPO_ROOT`, and `PHENIX_SOURCE_ROOT`. Missing workspace paths are terminal configuration errors; the wrapper never silently falls back to store data while development mode is enabled.

## Home Manager module

Enable the curated development tools through Home Manager:

```nix
{
  imports = [ inputs.phenix-packages.homeModules.devTools ];
  programs.phenix.devTools.enable = true;
}
```

The module is opt-in and adds the same package set to `home.packages`.

## Aggregate integration

The root `phenix` flake imports this repository's flake module and re-exports its
Home Manager surface. This repository owns only the shared package selection;
workstation configuration remains in `phenix-hosts` and desktop behavior remains in
`phenix-de`.

## Development

Enter the development shell with `nix develop`.

Run the read-only repository gate with `devenv test`. Apply configured maintenance fixes with `devenv tasks run maintenance:fix`.
