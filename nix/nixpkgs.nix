let
  src = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/a1c6434ebd46c455ff41bd6daa97f0a55df0d8c5.tar.gz";
    sha256 = "0kk6j5k1czz6a758vbzbq6dpfssm92rmagr62ljapav1yx0bah3b";
  };
in
  import src
