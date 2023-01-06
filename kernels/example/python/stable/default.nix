{
  self,
  system,
  ...
}: {
  kernel.python.stable = {
    enable = true;
    nixpkgs = self.inputs.nixpkgs-stable;
  };
}
