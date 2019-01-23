let
  src = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/a06b90a7dc683f303f2135c8dc849616a11b161a.tar.gz";
    sha256 = "0pnnrqf487r5vffi9gk2m30z9sqxam8nh4aaafx8s9v4qz13v2y3";
  };
in
  import src
