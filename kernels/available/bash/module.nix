{
  config,
  system,
  ...
}: {
  imports = [
    (import ./../../../modules/poetry.nix {
      kernelName = "bash";
      requiredRuntimePackages = [
        config.nixpkgs.bashInteractive
        config.nixpkgs.coreutils
      ];
    })
  ];
}
