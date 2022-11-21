{
  self,
  system,
  # custom arguments
  pkgs ? self.inputs.nixpkgs.legacyPackages.${system},
  name ? "haskell",
  displayName ? "Haskell",
  ihaskell ? pkgs.haskellPackages.ihaskell,
  extraHaskellFlags ? "",
  extraHaskellPackages ? (_: []),
}: let
  inherit (pkgs) haskellPackages lib stdenv writeScriptBin;

  ghcEnv = haskellPackages.ghcWithPackages (self: [ihaskell] ++ extraHaskellPackages self);

  ghciBin = writeScriptBin "ghciBin" ''
    ${ghcEnv}/bin/ghci "$@"
  '';

  ghcBin = writeScriptBin "ghcBin" ''
    ${ghcEnv}/bin/ghc "$@"
  '';

  ihaskellSh = writeScriptBin "ihaskell" ''
    #! ${stdenv.shell}
    export GHC_PACKAGE_PATH="$(echo ${ghcEnv}/lib/*/package.conf.d| tr ' ' ':'):$GHC_PACKAGE_PATH"
    export PATH="${lib.makeBinPath [ghcEnv]}:$PATH"
    if [[ ''${@: -1} == --Kernel* ]] ; then
      ${ihaskell}/bin/ihaskell ${extraHaskellFlags} -l $(${ghcEnv}/bin/ghc --print-libdir) "''${@:1:$#-1}"
    else
      ${ihaskell}/bin/ihaskell ${extraHaskellFlags} -l $(${ghcEnv}/bin/ghc --print-libdir) "$@"
    fi
  '';
in {
  inherit name displayName;
  language = "haskell";
  argv = [
    "${ihaskellSh}/bin/ihaskell"
    "kernel"
    "{connection_file}"
    "+RTS"
    "-M3g"
    "-N2"
    "-RTS"
  ];
  codemirrorMode = "haskell";
  logo64 = ./logo64.png;
}
