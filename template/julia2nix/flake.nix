{
  description = "Your jupyenv project";

  nixConfig.extra-substituters = [
    "https://tweag-jupyter.cachix.org"
  ];
  nixConfig.extra-trusted-public-keys = [
    "tweag-jupyter.cachix.org-1:UtNH4Zs6hVUFpFBTLaA4ejYavPo5EFFqgd7G7FxGW9g="
  ];

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.jupyenv.url = "github:tweag/jupyenv";
  inputs.julia2nix.url = "github:JuliaCN/julia2nix.jl";

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    jupyenv,
    ...
  } @ inputs:
    flake-utils.lib.eachSystem
    [
      flake-utils.lib.system.x86_64-linux
    ]
    (
      system: let
        inherit (jupyenv.lib.${system}) mkJupyterlabNew;
        jupyterlab = mkJupyterlabNew ({
          config,
          pkgs,
          ...
        }: {
          nixpkgs = import nixpkgs {
            overlays = [inputs.julia2nix.overlays.default];
            system = "x86_64-linux";
          };
          imports = [./kernels.nix];
        });
      in rec {
        packages = {inherit jupyterlab;};
        packages.default = jupyterlab;
        apps.default.program = "${jupyterlab}/bin/jupyter-lab";
        apps.default.type = "app";
      }
    );
}
