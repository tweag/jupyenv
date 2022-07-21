{pkgs ? import <nixpkgs> {}}: let
  name-ext = "jupyterlab-theme-solarized-dark";
  version-ext = "43de0c993ed3266e36b8dc5b5a2a7479ef67deda";

  name-jlab = "jupyterlab";
  version-jlab = "3.4.3";

  jupyterlabStagingFiles = pkgs.stdenv.mkDerivation {
    name = "${name-jlab}-staging-files";
    src = pkgs.fetchFromGitHub {
      owner = "jupyterlab";
      repo = "${name-jlab}";
      rev = "refs/tags/v${version-jlab}";
      sha256 = "sha256-IBDhBgifWx92BUrJLF0VaFsxlgrWGXv4/xl24oqlLy8=";
    };
    installPhase = ''
      mkdir -p $out
      cp -r jupyterlab/staging/* $out
    '';
  };

  #  jupyterlabStaging = pkgs.mkYarnPackage {
  #    name = "${name-jlab}-staging";
  #    src = "${jupyterlabStagingFiles}";
  #    postBuild = ''
  #      ls -Fho deps/@${name-jlab}/application-top/deps/@{name-jlab}
  #      exit 123
  #    '';
  #  };

  #  pkgs.yarn2nix-moretea.mkYarnModules {
  #    pname = "jlab-modules";
  #    version = "1.0.0";
  #    packageJSON = "${jupyterlabStagingFiles}/package.json";
  #    yarnLock = "${jupyterlabStagingFiles}/yarn.lock";
  #  }

  # checking the result of yarn.nix to test an offline mirror
  # pkgs.yarn2nix-moretea.mkYarnNix {yarnLock = "${jupyterlabStagingFiles}/yarn.lock";}

  extension = pkgs.fetchFromGitHub {
    owner = "AllanChain";
    repo = "${name-ext}";
    rev = "${version-ext}";
    sha256 = "sha256-N5R1AbDctso3uiV3kTnvLCpCl/5kAaEgEOht7+qT9v8=";
  };

  nodeModules = pkgs.mkYarnModules {
    pname = name-ext;
    version = version-ext;
    packageJSON = "${extension}/package.json";
    yarnLock = "${extension}/yarn.lock";
  };
in
  pkgs.runCommand "${name-ext}-${version-ext}" {buildInputs = [pkgs.python3Packages.jupyterlab pkgs.python3Packages.jupyter pkgs.nodejs];} ''
    mkdir extension .yarn
    export HOME=$PWD
    cp -R ${extension}/* extension

    pushd extension

    ln -s ${nodeModules}/node_modules ./node_modules

    ./node_modules/.bin/tsc

    jupyter labextension build .

    popd

    mkdir $out
  ''
