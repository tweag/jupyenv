let
  src = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/2a051165d53585630a602e831496f7157c519885.tar.gz";
    sha256 = "024g55m7kf8pn6gb4bn32rmwknaa5zfdaqwdg6d39fbypah2bjsb";
  };
in
  import src
