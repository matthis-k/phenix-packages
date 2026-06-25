{ ... }: {
  perSystem = { ... }: {
    phenix.overlays = [(final: prev: {
      phenix = (prev.phenix or {}) // {
        hello-packages = final.writeShellScriptBin "hello-packages" ''
          echo "hello from packages"
        '';
      };
    })];
  };
}
