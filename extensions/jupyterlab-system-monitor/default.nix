{pkgs}: let
  name = "jupyterlab-system-monitor";
  version = "0.8.0";

  extension = pkgs.stdenv.mkDerivation {
    name = "${name}-drv";
    src = pkgs.fetchFromGitHub {
      owner = "jtpio";
      repo = "${name}";
      rev = "refs/tags/${version}";
      sha256 = "0jv393bbjx8jda1nwsym3n37f5h47p63zdvw07vnxranwrpq41xl";
    };
    installPhase = ''
      mkdir -p $out
      cp -r * $out
    '';
    postPatch = ''
      # give the package.json a name and version for yarn2nix
      sed -i '0,/{/a\  "version": "${version}",' package.json
      sed -i '0,/{/a\  "name": "${name}",' package.json
    '';
  };
in
  pkgs.yarn2nix-moretea.mkYarnPackage rec {
    name = "jupyterlab-system-monitor";
    src = "${extension}";
  }
