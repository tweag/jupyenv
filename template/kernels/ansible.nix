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
  mkKernel ansible_stable {
    displayName = name;
  }
