{
  lib,
  python,
  poetry2nix,
}: let
  addNativeBuildInputs = drv: inputs:
    drv.overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ inputs;
    });

  poetryPackages = poetry2nix.mkPoetryPackages {
    inherit python;
    projectDir = ./.;
    overrides = poetry2nix.overrides.withDefaults (self: super: {
      argon2-cffi = addNativeBuildInputs super.argon2-cffi [self.flit-core];
      entrypoints = addNativeBuildInputs super.entrypoints [self.flit-core];
      jupyterlab-pygments = addNativeBuildInputs super.jupyterlab-pygments [self.jupyter-packaging];
      notebook-shim = addNativeBuildInputs super.notebook-shim [self.jupyter-packaging];
      pyparsing = addNativeBuildInputs super.pyparsing [self.flit-core];
      soupsieve = addNativeBuildInputs super.soupsieve [self.hatchling];
      testpath = addNativeBuildInputs super.testpath [self.flit-core];
    });
  };

  # Transform python3.9-xxxx-1.8.0 to xxxx
  toName = s:
    lib.strings.concatStringsSep "-"
    (lib.lists.drop 1 (lib.lists.init (lib.strings.splitString "-" s)));

  # Makes the flat list an attrset
  packages = builtins.foldl' (obj: drv: {"${toName drv.name}" = drv;} // obj) {} poetryPackages.poetryPackages;
in
  packages.jupyterlab
