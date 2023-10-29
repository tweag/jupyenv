{
  lib,
  self,
  system,
  kernelName ? "",
  overlays ? [],
}: let
  nixpkgsArg = x:
    if (lib.hasAttr "legacyPackages" x)
    then x.legacyPackages.${system}.appendOverlays overlays
    else x.appendOverlays overlays;
in
  lib.mkOption {
    type = lib.mkOptionType {
      name = "packages";
      description = "instance of nixpkgs";
      check = x: (lib.isAttrs (nixpkgsArg x)) && (lib.hasAttr "path" (nixpkgsArg x));
    };
    default =
      if kernelName == "scala"
      then nixpkgsArg self.inputs.nixpkgs-stable
      else if kernelName == "julia"
      then nixpkgsArg self.inputs.nixpkgs-julia
      else nixpkgsArg self.inputs.nixpkgs;
    defaultText = lib.literalExpression "self.inputs.nixpkgs";
    example = lib.literalExpression "self.inputs.nixpkgs";
    description = lib.mdDoc ''
      nixpkgs flake input to be used for jupyenv
    '';
  }
