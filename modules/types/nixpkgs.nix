{
  lib,
  self,
  system,
  kernelName ? "",
  overlays ? [],
}: let
  nixpkgsArg = x:
    if (lib.hasAttr "legacyPackages" x)
    then x.legacyPackages.${system}
    else x;
  applyOverlays = x: (nixpkgsArg x).appendOverlays overlays;
in
  lib.mkOption {
    type = lib.mkOptionType {
      name = "packages";
      description = "instance of nixpkgs";
      check = x: (lib.isAttrs (nixpkgsArg x)) && (lib.hasAttr "path" (nixpkgsArg x));
    };
    default =
      if kernelName == "scala"
      then applyOverlays self.inputs.nixpkgs-stable
      else applyOverlays self.inputs.nixpkgs;
    defaultText = lib.literalExpression "self.inputs.nixpkgs";
    example = lib.literalExpression "self.inputs.nixpkgs";
    description = ''
      nixpkgs flake input to be used for jupyenv
    '';
    apply = x: nixpkgsArg x;
  }
