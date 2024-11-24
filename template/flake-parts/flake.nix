{
  description = "Your jupyenv project";

  nixConfig.extra-substituters = [
    "https://tweag-jupyter.cachix.org"
  ];
  nixConfig.extra-trusted-public-keys = [
    "tweag-jupyter.cachix.org-1:UtNH4Zs6hVUFpFBTLaA4ejYavPo5EFFqgd7G7FxGW9g="
  ];

  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.jupyenv.url = "github:tweag/jupyenv";

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.jupyenv.flakeModule
      ];
      systems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
      perSystem = {
        lib,
        pkgs,
        ...
      }: {
        jupyenv.kernels = ./kernels.nix;
      };
    };
}
