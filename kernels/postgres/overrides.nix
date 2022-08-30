final: prev: let
  addNativeBuildInputs = drvName: inputs: {
    "${drvName}" = prev.${drvName}.overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ inputs;
    });
  };
in {
  postgres-kernel = prev.postgres-kernel.overridePythonAttrs (old: {
    postPatch = ''
      # remove custom install
      sed -i "s/cmdclass={'install': install_with_kernelspec},//" setup.py
    '';
  });
}
