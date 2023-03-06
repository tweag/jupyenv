{pkgs, config, ...}: {
  kernel.python.minimal = {
    enable = true;
    poetryEnv = config.kernel.python.minimal.nixpkgs.poetry2nix.mkPoetryEnv {
      projectDir = ./python;
      preferWheels = true;
      groups = ["jupyter"];
      # https://github.com/tweag/jupyenv/pull/450#issuecomment-1455026847
      # poetryEnv could be another way to solve the ``infinite recursion encountered` of overrdies
      overrides = import ./python/overrides.nix config.kernel.python.minimal.nixpkgs.poetry2nix;
    };
  };
}
