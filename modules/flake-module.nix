_: {
  # Exports flake-level metadata for the consumer-side flakeModules.default API.
  perSystem = _: { };
  flake.phenixPackages = {
    description = ''
      Phenix curated package set with dev-tools package outputs and an
      optional Home Manager module (homeModules.devTools). Enable with:
        programs.phenix.devTools.enable = true;
    '';
  };
}
