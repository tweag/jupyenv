let
  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath {};

  ihaskellWithPackages = jupyter.kernels.iHaskellWith {
      name = "Local";
      packages = p: [
        (p.callPackage ./my-haskell-package {})
      ];
    };

  jupyterlabWithKernels =
    jupyter.jupyterlabWith {
      kernels = [ ihaskellWithPackages ];
      directory = jupyter.mkDirectoryFromLockFile {
        yarnlock = ./yarn.lock;
        packagejson = ./package.json;
        sha256 = "1ak8i3kydn4l3vk24lp19j185s2gi0gck26k77v2rkj9ql6j9wci";
      };
    };
in
  jupyterlabWithKernels.env
