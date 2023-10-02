{
  lib,
  config,
  self,
  kernelName,
}: let
  findKernel = name: list:
    if (lib.intersectLists [name] list) != []
    then true
    else false;

  overlays =
    if (findKernel kernelName ["python" "bash" "c" "elm" "zsh"])
    then [
      self.inputs.poetry2nix.overlay
    ]
    else if kernelName == "rust"
    then [
      self.inputs.rust-overlay.overlays.default
    ]
    else [];
in
  overlays
