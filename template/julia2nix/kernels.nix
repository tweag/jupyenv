{
  pkgs,
  config,
  ...
}: {
  kernel.julia.minimal = {
    enable = true;
    julia = pkgs.lib.julia-wrapped {
      package = pkgs.julia_nightly-bin;
      meta.mainProgram = "julia";
      enable = {
        GR = true;
        python =
          pkgs.python3.buildEnv.override
          {
            extraLibs = with pkgs.python3Packages; [xlrd matplotlib];
          };
      };
      # makeWrapperArgs = ["--add-flags" "-L''${./startup.jl}"];
    };
  };
}
