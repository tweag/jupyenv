{
  description = "Declarative and reproducible Jupyter environments - powered by Nix";

  nixConfig.extra-substituters = [
    "https://tweag-jupyter.cachix.org"
  ];
  nixConfig.extra-trusted-public-keys = [
    "tweag-jupyter.cachix.org-1:UtNH4Zs6hVUFpFBTLaA4ejYavPo5EFFqgd7G7FxGW9g="
  ];

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.05";
  inputs.flake-compat.url = "github:edolstra/flake-compat";
  inputs.flake-compat.flake = false;
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.ihaskell.url = "github:ihaskell/ihaskell";
  inputs.ihaskell.inputs.nixpkgs.follows = "nixpkgs";
  inputs.ihaskell.inputs.flake-compat.follows = "flake-compat";
  inputs.ihaskell.inputs.flake-utils.follows = "flake-utils";
  inputs.nix-dart.url = "github:djacu/nix-dart";
  inputs.nix-dart.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nix-dart.inputs.flake-utils.follows = "flake-utils";
  inputs.npmlock2nix.url = "github:nix-community/npmlock2nix/0ba0746d62974403daf717cded3f24c617622bc7";
  inputs.npmlock2nix.flake = false;
  inputs.opam-nix.url = "github:tweag/opam-nix/75199758e1954f78286e7e79c0e3916e28b732b0";
  inputs.opam-nix.inputs.flake-compat.follows = "flake-compat";
  inputs.opam-nix.inputs.flake-utils.follows = "flake-utils";
  inputs.opam-nix.inputs.nixpkgs.follows = "nixpkgs";
  inputs.pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  inputs.pre-commit-hooks.inputs.flake-utils.follows = "flake-utils";
  inputs.pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
  inputs.poetry2nix.url = "github:nix-community/poetry2nix";
  inputs.poetry2nix.inputs.flake-utils.follows = "flake-utils";
  inputs.poetry2nix.inputs.nixpkgs.follows = "nixpkgs";
  inputs.rust-overlay.url = "github:oxalica/rust-overlay";
  inputs.rust-overlay.inputs.flake-utils.follows = "flake-utils";
  inputs.rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    flake-compat,
    flake-utils,
    ihaskell,
    nix-dart,
    npmlock2nix,
    opam-nix,
    pre-commit-hooks,
    poetry2nix,
    rust-overlay,
  }: let
    inherit (nixpkgs) lib;

    SYSTEMS = [
      flake-utils.lib.system.x86_64-linux
      flake-utils.lib.system.x86_64-darwin
    ];

    kernelLib = import ./lib/kernels.nix {inherit self lib;};
  in
    (flake-utils.lib.eachSystem SYSTEMS (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};

        python = pkgs.python3;
        poetry2nixPkgs = import "${poetry2nix}/default.nix" {inherit pkgs poetry;};
        poetry = pkgs.callPackage "${poetry2nix}/pkgs/poetry" {inherit python;};

        baseArgs = {
          inherit self system;
        };

        pre-commit = pre-commit-hooks.lib.${system}.run {
          src = self;
          hooks = {
            alejandra.enable = true;
            typos = {
              enable = true;
              types = ["file"];
              files = "\\.((txt)|(md)|(nix)|\\d)$";
            };
          };
          excludes = ["^\\.jupyter/"]; # JUPYTERLAB_DIR
          settings = {
            typos.write = true;
          };
        };

        update-poetry-lock =
          pkgs.writeShellApplication
          {
            name = "update-poetry-lock";
            runtimeInputs = [poetry];
            text = ''
              shopt -s globstar
              for lock in **/poetry.lock; do
              (
                echo Updating "$lock"
                cd "$(dirname "$lock")"
                poetry update
              )
              done
            '';
          };

        jupyenvLib = lib.makeScope lib.callPackageWith (final: {
          inherit self system pkgs lib python nix-dart baseArgs kernelLib;
          docsLib = final.callPackage ./lib/docs.nix {};
          jupyterLib = final.callPackage ./lib/jupyter.nix {};
        });
        inherit (jupyenvLib) docsLib jupyterLib;

        examples = kernelLib.mapKernelsFromPath (self + /examples) ["example"];
        exampleJupyterlabKernelsNew = (
          lib.mapAttrs'
          (
            name: value:
              lib.nameValuePair
              ("jupyterlab-kernel-" + name)
              (jupyterLib.mkJupyterlabNew value)
          )
          examples
        );

        exampleJupyterlabAllKernelsNew =
          jupyterLib.mkJupyterlabNew (builtins.attrValues examples);
      in {
        lib =
          jupyterLib
          // kernelLib
          // {};
        packages =
          {
            jupyterlab-new = jupyterLib.mkJupyterlabNew ./config.nix;
            jupyterlab = jupyterLib.jupyterlabEnvWrapped baseArgs;
            jupyterlab-all-example-kernels = exampleJupyterlabAllKernelsNew;
            pub2nix-lock = nix-dart.packages."${system}".pub2nix-lock;
            inherit update-poetry-lock;
            inherit (docsLib) docs mkdocs;
            default = jupyterLib.jupyterlabEnvWrapped baseArgs;
          }
          // exampleJupyterlabKernelsNew;
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.alejandra
            pkgs.typos
            poetry2nixPkgs.cli
            poetry
            pkgs.rnix-lsp
            self.packages."${system}".update-poetry-lock
            docsLib.mkdocs
          ];
          shellHook = ''
            ${pre-commit.shellHook}
          '';
        };
        checks = {
          inherit pre-commit;
          jupyterlabEnv = jupyterLib.jupyterlabEnvWrapped baseArgs;
        };
        apps = {
          update-poetry-lock =
            flake-utils.lib.mkApp
            {drv = self.packages."${system}".update-poetry-lock;};
        };
      }
    ))
    // {
      templates.default = {
        path = ./template;
        description = "Boilerplate for your jupyenv project";
        welcomeText = ''
          You have created a jupyenv template.

          Run `nix run` to immediately try it out.

          See the jupyenv documentation for more information.

            https://jupyenv.io/documentation/getting-started/
        '';
      };
    };
}
