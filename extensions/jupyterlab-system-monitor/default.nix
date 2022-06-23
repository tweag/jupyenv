{pkgs}: let
  name = "jupyterlab-system-monitor";
  version = "0.8.0";

  extension = pkgs.fetchFromGitHub {
    owner = "jtpio";
    repo = "${name}";
    rev = "refs/tags/{$version}";
    sha256 = "0jv393bbjx8jda1nwsym3n37f5h47p63zdvw07vnxranwrpq41xl";
    #fetchSubmodules = true;
    postFetch = ''
      # give the package a name for yarn
      sed -i '0,/{/a\  "name": "${name}",' package.json
      head package.json
      exit 123
    '';
  };
in
  pkgs.yarn2nix-moretea.mkYarnPackage rec {
    name = "jupyterlab-system-monitor";
    src = "${extension}";
  }
