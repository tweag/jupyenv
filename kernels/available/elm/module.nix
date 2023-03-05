{
  config,
  system,
  ...
}: {
  imports = [
    (import ./../../../modules/poetry.nix {
      requiredRuntimePackages = [
        config.nixpkgs.elmPackages.elm
      ];
      kernelName = "elm";
    })
  ];
}
