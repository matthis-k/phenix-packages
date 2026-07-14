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

Use the inline Tend helpers:

- `repo-hook` — verify staged changes.
- `repo-pushgate` — run the complete pre-push gate.
- `repo-check` — run the manual verification profile.
- `repo-fix` — apply the configured safe fixes.
