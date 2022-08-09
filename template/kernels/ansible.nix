{
  mkKernel,
  kernels,
  name,
  ...
} @ args: let
  ansible_stable = kernels.ansible.override {
    pkgs = args.pkgs_stable;
  };
in
  mkKernel kernels.ipython {
    displayName = name;
  }
