{
  pkgs,
  config,
  ...
}: let
  cfg-science-example = config.kernel.python.science-example;
in {
  kernel.python.science-example = {
    enable = true;
    env = cfg-science-example.nixpkgs.python3.withPackages (ps:
      with ps; [
        ps.ipykernel
        ps.scipy
        ps.matplotlib
      ]);
    # extraPackages = ps: [
    #   ps.numpy
    #   ps.scipy
    #   ps.matplotlib
    # ];
  };
}
