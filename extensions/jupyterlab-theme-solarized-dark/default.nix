{pkgs ? import <nixpkgs> {}}: let
  name-ext = "jupyterlab-theme-solarized-dark";
  version-ext = "43de0c993ed3266e36b8dc5b5a2a7479ef67deda";

  extension = pkgs.stdenv.mkDerivation {
    name = "${name-ext}-drv";
    src = pkgs.fetchFromGitHub {
      owner = "AllanChain";
      repo = "${name-ext}";
      rev = "${version-ext}";
      sha256 = "sha256-N5R1AbDctso3uiV3kTnvLCpCl/5kAaEgEOht7+qT9v8=";
    };
    installPhase = ''
      mkdir -p $out
      cp -r * $out
    '';
  };

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

  jupyterlabStaging = pkgs.mkYarnPackage {
    name = "${name-jlab}-staging";
    src = "${jupyterlabStagingFiles}";
    postBuild = ''
      ls -Fho deps/@${name-jlab}/application-top/deps/@{name-jlab}
      exit 123
    '';
  };
in
  # checking the result of yarn.nix to test an offline mirror
  pkgs.yarn2nix-moretea.mkYarnNix {yarnLock = "${jupyterlabStagingFiles}/yarn.lock";}
#  pkgs.mkYarnPackage rec {
#    name = name-ext;
#    src = "${extension}";
#
#    buildPhase = ''
#      pushd deps/${name}
#      node ${jupyterlabStagingFiles}/yarn.js --offline tsc
#      # node ${jupyterlabStagingFiles}/yarn.js --offline
#      popd
#    '';
#  }

