{
  config,
  system,
  ...
}: {
  imports = [
    (import ./../../../modules/poetry.nix {
      requiredRuntimePackages = [
        config.nixpkgs.zsh
        config.nixpkgs.coreutils
      ];
      kernelName = "zsh";
    })
  ];
}
