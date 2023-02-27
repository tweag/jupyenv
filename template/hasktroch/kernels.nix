{hasktorch}: {pkgs, ...}: let
  htorch = hasktorch.packages.${pkgs.system};
in {
  kernel.haskell.minimal = {
    enable = true;
    extraHaskellPackages = ps:
      with ps; [
        ps.http-client
        ps.http-conduit
        # htorch."libtorch-ffi-cuda-11:lib:libtorch-ffi"
        htorch."hasktorch-cpu:lib:hasktorch"
        # htroch."libtorch-ffi-cpu:lib:libtorch-ffi"
      ];
  };
}
