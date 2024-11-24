{pkgs, ...}: {
  kernel.julia.minimal-example = {
    enable = true;
    override = {
      augmentedRegistry = pkgs.fetchFromGitHub {
        owner = "CodeDownIO";
        repo = "General";
        rev = "840f93574326361e2614fc5a4c2413f07840215a";
        sha256 = "sha256-UedaTpQwkuSZ/o4kLX/Jg8eDnL5IFI4XfYsJMRwBAKE=";
      };
      # Precompile = true;
    };
    extraJuliaPackages = [
      "Plots"
    ];
  };
}
