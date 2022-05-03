let
  addNativeBuildInputs = drv: inputs:
    drv.overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ inputs;
    });
in
  {
    self,
    pkgs,
    poetry2nix,
    # https://github.com/nix-community/poetry2nix#mkPoetryPackages
    projectDir ? null,
    pyproject ? null,
    poetrylock ? null,
    overrides ? null,
    python ? null,
    editablePackageSources ? {},
  }: let
    env = poetry2nix.mkPoetryPackages {
      projectDir =
        if projectDir == null
        then self + "/kernels/ansible"
        else projectDir;
      pyproject =
        if pyproject == null
        then projectDir + "/pyproject.toml"
        else pyproject;
      poetrylock =
        if poetrylock == null
        then projectDir + "/poetry.lock"
        else poetrylock;
      overrides =
        if overrides == null
        then
          poetry2nix.overrides.withDefaults (self: super: {
            ansible-runner = addNativeBuildInputs super.ansible-runner [self.pbr];
            argon2-cffi = addNativeBuildInputs super.argon2-cffi [self.flit-core];
            jupyterlab-pygments = addNativeBuildInputs super.jupyterlab-pygments [self.jupyter-packaging];
            pyparsing = addNativeBuildInputs super.pyparsing [self.flit-core];
            soupsieve = addNativeBuildInputs super.soupsieve [self.hatchling];
            ansible-kernel = super.ansible-kernel.overridePythonAttrs (old: {
              postPatch = ''
                # remove when merged
                # https://github.com/ansible/ansible-jupyter-kernel/pull/82
                touch LICENSE.md

                # remove custom install
                sed -i "s/cmdclass={'install': Installer},//" setup.py
              '';
            });
          })
        else overrides;
      python =
        if python == null
        then pkgs.python3
        else python;
      inherit editablePackageSources;
    };
  in
    {
      name ? "ansible",
      displayName ? "Ansible", # TODO: add Ansible version
      language ? "ansible",
      argv ? [
        "${env.python.interpreter}"
        "-m"
        "ansible_kernel"
        "-f"
        "{connection_file}"
      ],
      codemirror_mode ? "yaml",
      logo64 ? ./logo64.png,
    }: {
      inherit
        name
        displayName
        language
        argv
        codemirror_mode
        logo64
        ;
    }
