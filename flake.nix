{
  description = "declarative and reproducible Jupyter environments - powered by Nix";

  nixConfig.extra-substituters = "https://jupyterwith.cachix.org";
  nixConfig.extra-trusted-public-keys = "jupyterwith.cachix.org-1:/kDy2B6YEhXGJuNguG1qyqIodMyO4w8KwWH4/vAc7CI=";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  inputs.pre-commit-hooks.inputs.flake-utils.follows = "flake-utils";
  inputs.pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.ihaskell.url = "github:gibiansky/IHaskell";
  inputs.ihaskell.inputs.nixpkgs.follows = "nixpkgs";
  inputs.ihaskell.inputs.flake-utils.follows = "flake-utils";
  #inputs.ihaskell.inputs.hls.inputs.flake-utils.follows = "flake-utils";
  #inputs.ihaskell.inputs.hls.inputs.nixpkgs.follows = "nixpkgs";
  #inputs.ihaskell.inputs.hls.inputs.pre-commit-hooks.follows = "pre-commit-hooks";

  outputs = {
    self,
    flake-utils,
    pre-commit-hooks,
    nixpkgs,
    ihaskell,
  }: let
    SYSTEMS = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    overlays = {
      jupyterWith = import ./nix/overlay.nix;
      haskell = (import ./nix/haskell-overlay.nix) ihaskell;
      python = import ./nix/python-overlay.nix;
    };
  in
    (flake-utils.lib.eachSystem SYSTEMS (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            overlays.jupyterWith
            overlays.haskell
            overlays.python
          ];
        };
        pythonKernel = pkgs.jupyterWith.kernels.iPythonWith {
          name = "ipython-kernel";
          ignoreCollisions = true;
        };
        haskellKernel = pkgs.jupyterWith.kernels.iHaskellWith {
          name = "ihaskell-kernel";
          packages = p: with p; [vector aeson];
          extraIHaskellFlags = "--codemirror Haskell"; # for jupyterlab syntax highlighting
          haskellPackages = pkgs.haskellPackages;
        };
        tests = import ./tests {inherit pkgs;};
        pre-commit = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
          };
        };
      in rec {
        lib.jupyterWith = pkgs.jupyterWith;
        packages = {
          jupyterWith = pkgs.jupyterWith;
          jupyterEnvironment = pkgs.jupyterWith.jupyterlabWith {
            kernels = [pythonKernel haskellKernel];
          };
          inherit (tests) build;
          inherit (tests.kernel-tests) core;
        };
        devShell = pkgs.mkShell {
          packages = [
            #packages.jupyterEnvironment
            pkgs.alejandra
          ];
          shellHook = ''
            ${pre-commit.shellHook}
          '';
        };
        defaultPackage = packages.jupyterEnvironment;
        checks = {
          inherit pre-commit;
          inherit (tests) build;
          inherit (tests.kernel-tests) core;
        };
      }
    ))
    // {inherit overlays;};
}
