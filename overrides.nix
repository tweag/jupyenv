pkgs: final: prev:
(pkgs.poetryBuildSystems final prev)
// {
  cffi = prev.cffi.overridePythonAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs or [] ++ [pkgs.pkg-config final.setuptools];
    buildInputs = old.buildInputs or [] ++ [pkgs.libffi];
    prePatch =
      (old.prePatch or "")
      + pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
        # Remove setup.py impurities
        substituteInPlace setup.py --replace "'-iwithsysroot/usr/include/ffi'" ""
        substituteInPlace setup.py --replace "'/usr/include/ffi'," ""
        substituteInPlace setup.py --replace '/usr/include/libffi' '${pkgs.lib.getDev pkgs.libffi}/include'
      '';
  });

  nbconvert = prev.nbconvert.overridePythonAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs or [] ++ [final.hatchling];
    postPatch =
      pkgs.lib.optionalString (pkgs.lib.versionAtLeast final.nbconvert.version "6.5.0") ''
        substituteInPlace \
          ./nbconvert/exporters/templateexporter.py \
          --replace \
          'root_dirs.extend(jupyter_path())' \
          'root_dirs.extend(jupyter_path() + [os.path.join("@out@", "share", "jupyter")])' \
          --subst-var out
      ''
      + pkgs.lib.optionalString (pkgs.lib.versionAtLeast final.nbconvert.version "7.0") ''
        substituteInPlace \
          ./hatch_build.py \
          --replace \
          'if self.target_name not in ["wheel", "sdist"]:' \
          'if True:'
      '';
  });

  testbook = prev.testbook.overridePythonAttrs (old: {
    postPatch = ''
      mkdir ./tmp
      ${pkgs.unzip}/bin/unzip dist/testbook-${old.version}-py3-none-any.whl -d ./tmp
      sed -i -e "s|if not any(arg.startswith('--Kernel|if False and not any(arg.startswith('--Kernel|" tmp/testbook/client.py
      rm dist/testbook-${old.version}-py3-none-any.whl
      pushd tmp
        ${pkgs.zip}/bin/zip -r ../dist/testbook-${old.version}-py3-none-any.whl ./*
      popd
      rm -rf tmp
    '';
  });
}
