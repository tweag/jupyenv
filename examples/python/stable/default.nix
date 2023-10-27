{
  self,
  system,
  ...
}: {
  kernel.python.stable-example = {
    enable = true;
    nixpkgs = self.inputs.nixpkgs-stable.legacyPackages.${system};
  };
}
