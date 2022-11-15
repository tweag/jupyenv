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
}
