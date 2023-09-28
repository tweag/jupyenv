top @ {
  config,
  flake-parts-lib,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  # User options defined in perSystem below.
  options.jupyenv.flake = mkOption {
    internal = true;
    description = "The jupyenv flake";
  };

  options.perSystem = flake-parts-lib.mkPerSystemOption (
    {
      config,
      pkgs,
      system,
      ...
    }: let
      jupyenv = top.config.jupyenv.flake;
      cfg = config.jupyenv;
      inherit (jupyenv.lib.${system}) mkJupyterlabNew;

      jupyterlab = mkJupyterlabNew ({...}: {
        nixpkgs = pkgs;
        imports = [cfg.kernels];
      });
    in {
      options.jupyenv = {
        kernels = mkOption {
          type = types.deferredModule;
          description = ''
            A module that defines all the kernels to be installed.

            You may reference a file, or multiple files using `imports`.
          '';
        };
        pkgs = mkOption {
          type = types.pkgs;
          description = ''
            Nixpkgs instance to use.
          '';
          default = pkgs;
          defaultText = lib.literalMD "`pkgs` module argument";
        };
        packageName = mkOption {
          description = ''
            Attribute name to use for the generated `package` and `apps` definitions.

            You will be able to run `nix run .#<packageName>` to start jupyterlab.

            The default value, `"default"` also allows `nix run` without argument, but may compete with other modules' packages.
          '';
          default = "default";
        };
      };

      config = {
        packages.${cfg.packageName} = jupyterlab;
        apps.${cfg.packageName} = {
          program = "${jupyterlab}/bin/jupyter-lab";
          type = "app";
        };
      };
    }
  );
}
