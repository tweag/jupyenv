{
  lib,
  self,
  system,
}: let
  nixpkgsArg = x:
    if (lib.hasAttr "legacyPackages" x)
    then x.legacyPackages.${system}
    else x;
in
  lib.mkOption {
    type = lib.mkOptionType {
      name = "packages";
      description = "instance of nixpkgs";
      check = x: (lib.isAttrs (nixpkgsArg x)) && (lib.hasAttr "path" (nixpkgsArg x));
    };
    default = self.inputs.nixpkgs;
    defaultText = lib.literalExpression "self.inputs.nixpkgs";
    example = lib.literalExpression "self.inputs.nixpkgs";
    description = lib.mdDoc ''
      nixpkgs flake input to be used for this jupyenv.
    '';
    apply = x: nixpkgsArg x;
  }
