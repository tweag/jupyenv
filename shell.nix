{ nixpkgs ? import ./nix {}
, kernelFile ? null }:
let 
  jupyter = import ./. {};
  defaultKernels = 
      with jupyter.kernels; [
              # Sample Haskell kernel
              ( iHaskellWith {
                  name = "hvega";
                  packages = p: with p; [
                    hvega
                    PyF
                    formatting
                    string-qq
                  ];
                })
          
              # Sample Python kernel
              ( iPythonWith {
                  name = "numpy";
                  packages = p: with p; [
                    numpy
                  ];
                })
              ];

  callWithKernels = path:
              let kernelDrv = import path;
              in kernelDrv (builtins.intersectAttrs (builtins.functionArgs kernelDrv) jupyter.kernels);
in
  (jupyter.jupyterlabWith {
    kernels=if isNull kernelFile then defaultKernels else [ (callWithKernels kernelFile) ];
  }).env
