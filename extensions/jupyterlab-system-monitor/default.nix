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
  pkgs.mkYarnPackage rec {
    # pkgs.yarn2nix-moretea.mkYarnPackage rec {
    name = "jupyterlab-system-monitor";
    src = "${extension}";

    # From nixpkgs manual
    # The configure phase can sometimes fail because it tries to be too clever.
    # One common override is:
    # configurePhase = "ln -s $node_modules node_modules";

    linkDirFunction = ''
      linkDirToDirLinks() {
        target=$1
        if [ ! -f "$target" ]; then
          mkdir -p "$target"
        elif [ -L "$target" ]; then
          local new=$(mktemp -d)
          trueSource=$(realpath "$target")
          if [ "$(ls $trueSource | wc -l)" -gt 0 ]; then
            ln -s $trueSource/* $new/
          fi
          rm -r "$target"
          mv "$new" "$target"
        fi
      }
    '';

    configurePhase = ''
      runHook preConfigure
      for localDir in npm-packages-offline-cache node_modules; do
        if [[ -d $localDir || -L $localDir ]]; then
          echo "$localDir dir present. Removing."
          rm -rf $localDir
        fi
      done
      # move convent of . to ./deps/''${pname}
      mv $PWD $NIX_BUILD_TOP/temp
      mkdir -p "$PWD/deps/''${pname}"
      rm -fd "$PWD/deps/''${pname}"
      mv $NIX_BUILD_TOP/temp "$PWD/deps/''${pname}"
      cd $PWD
      ln -s ''${deps}/deps/''${pname}/node_modules "deps/''${pname}/node_modules"
      cp -r $node_modules node_modules
      chmod -R +w node_modules

      # For some reason, escaping the $ on the following line did not put
      # linkDirToDirLinks in scope. So I added it above till I can figure it out.
      ${linkDirFunction}
      linkDirToDirLinks "$(dirname node_modules/''${pname})"

      # Trying to figure out why the last line in this block causes the build
      # to fail. It looks like the names are already linked and commenting it
      # out lets the build proceed and succeed.
      # echo "deps/''${pname}"
      # ls -Fho deps/''${pname}
      # echo "node_modules/''${pname}"
      # ls -Fho node_modules/''${pname}
      # ln -s "deps/''${pname}" "node_modules/''${pname}"

      ''${workspaceDependencyCopy}
      # Help yarn commands run in other phases find the package
      echo "--cwd deps/''${pname}" > .yarnrc
      runHook postConfigure
    '';
  }
