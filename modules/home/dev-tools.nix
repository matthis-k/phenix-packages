{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.programs.phenix.devTools;
in
{
  options.programs.phenix.devTools = {
    enable = mkEnableOption "Phenix curated dev-tools package set";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      git
      gh
      ripgrep
      fd
      fzf
      bat
      eza
      delta
      jq
      htop
      btop
      tmux
      lazygit
      zoxide
      curl
      wget
      unzip
      starship
    ];
  };
}
