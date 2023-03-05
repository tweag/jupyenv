{
  config,
  system,
  ...
}: {
  imports = [
    (import ./../../../modules/poetry.nix {
      requiredRuntimePackages = [
        config.nixpkgs.stdenv.cc
      ];
      kernelName = "c";
    })
  ];
}
