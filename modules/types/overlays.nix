{
  lib,
  config,
  self,
  kernelName,
}: let
  overlays =
    if (lib.elem kernelName ["python" "bash" "c" "elm" "zsh" "postgres"])
    then [
      self.inputs.poetry2nix.overlays.default
    ]
    else if kernelName == "rust"
    then [
      self.inputs.rust-overlay.overlays.default
    ]
    else [];
in
  overlays
