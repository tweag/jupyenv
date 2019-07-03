let
  src = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/3d4459e31bdccfb581e27dfffbec44d62d121349.tar.gz";
    sha256 = "08pzpwxjrf8p7z0hcw5nhwrm6rw180g5446aandl41zvqvdjhigb";
  };
in
  import src
