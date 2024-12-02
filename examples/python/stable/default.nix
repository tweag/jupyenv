{
  self,
  system,
  ...
}: {
  kernel.python.stable-example = {
    enable = true;
    nixpkgs = import self.inputs.nixpkgs-stable {
      inherit system;
      overlays = [
        self.inputs.poetry2nix.overlays.default
      ];
    };
  };
}
