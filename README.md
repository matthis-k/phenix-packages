# phenix-packages

Phenix curated package set for NixOS and Home Manager.

Part of the NewXOS migration (Chunk 3).

## Packages

The flake exports the following packages under `packages.<system>.<name>`:

| Package    | Description                          |
|------------|--------------------------------------|
| git        | Distributed version control system   |
| gh         | GitHub CLI                           |
| ripgrep    | Line-oriented search tool            |
| fd         | Simple, fast alternative to `find`   |
| fzf        | Command-line fuzzy finder            |
| bat        | Cat clone with syntax highlighting   |
| eza        | Modern `ls` replacement              |
| delta      | Syntax-highlighting pager for git    |
| jq         | Command-line JSON processor          |
| htop       | Interactive process viewer           |
| btop       | Resource monitor                     |
| tmux       | Terminal multiplexer                 |
| lazygit    | Terminal UI for git                  |
| zoxide     | Smarter `cd` command                 |
| curl       | HTTP client                          |
| wget       | Network downloader                   |
| unzip      | Zip file extractor                   |
| starship   | Minimal, fast shell prompt           |

Run individually: `nix run github:matthis-k/phenix-packages#<name>`

## Home Manager module

Enable curated dev-tools via Home Manager:

```nix
{
  imports = [ inputs.phenix-packages.homeModules.devTools ];
  programs.phenix.devTools.enable = true;
}
```

This adds the same 18 packages to `home.packages`. The module is opt-in and
disabled by default.

## Root integration

Root flake integration (adding `phenix-packages` to root's nixosConfigurations,
homeConfigurations, and devShells) is tracked in Chunk 5 of the migration.

## Development

Enter the dev shell: `nix develop`

Use `tend` for local checks:
- `repo-check` — run all verifications
- `repo-fix` — auto-format and lint

## Current state

- [x] Dev-tools package set (Chunk 3)
- [ ] Root integration (Chunk 5)
- [ ] Chunk 6: Final documentation
