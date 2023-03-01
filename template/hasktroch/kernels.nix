{
  hasktorch,
  nixpkgs,
}: {pkgs, ...}: let
  htorch = hasktorch.packages.${pkgs.system};
  hnixpkgs =
    (
      import hasktorch.inputs.nixpkgs {
        inherit (pkgs) system;
        # inherit (hasktorch.inputs.haskell-nix) config;
        config.allowBroken = true;
      }
    )
      .appendOverlays [
         hasktorch.inputs.haskell-nix.overlay
         hasktorch.inputs.iohkNix.overlays.haskell-nix-extra
         hasktorch.inputs.tokenizers.overlay
         hasktorch.overlays.dev-tools
        (hasktorch.overlays.hasktorch-project "cpu")
        # (hasktorch.overlays.hasktorch-project "cdua")
      ];
  # hnixpkgs.pkgs.hasktorchProject.ghcWithPackages (ps: [ps.hasktorch]);
  hProject = hnixpkgs.pkgs.hasktorchProject;
in {
  kernel.haskell.minimal = {
    # nixpkgs = hnixpkgs;
    enable = true;
    # https://github.com/hasktorch/hasktorch/blob/master/flake.nix#L84
    haskellCompiler = "ghc924";
    extraHaskellPackages = ps:
      with ps; [
        # ps.libtorch-ffi
        # ps.hasktorch
        # htorch."libtorch-ffi-cuda-11:lib:libtorch-ffi"
        # htorch."hasktorch-cpu:lib:hasktorch"
      ];
  };
}
