final: prev: {
  nix-kernel = prev.nix-kernel.overridePythonAttrs (old: {
    postPatch = ''
      # remove custom install
      sed -i "s/cmdclass={'install': install_with_kernelspec},//" setup.py
    '';
  });
}
