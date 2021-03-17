let
  src = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/3a7674c896847d18e598fa5da23d7426cb9be3d2.tar.gz";
    sha256 = "130d460iq6yarsfd3x03wrngsjrzbc5gam6xfsykyw3k0pbw4cl4";
  };
in
import src
