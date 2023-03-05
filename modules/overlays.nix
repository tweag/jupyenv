{
  lib,
  config,
  self,
  kernelName,
}: let
  overlays =
    if (kernelName) == "python"
    then [
      self.inputs.poetry2nix.overlay
    ]
    else if kernelName == "rust"
    then [
      self.inputs.rust-overlay.overlays.default
    ]
    else if kernelName == "bash"
    then [
      self.inputs.poetry2nix.overlay
    ]
    else [
    ];
in
  overlays
