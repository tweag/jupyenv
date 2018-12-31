let
  src = builtins.fetchGit {
    url = "http://github.com/NixOS/nixpkgs";
    rev = "a06b90a7dc683f303f2135c8dc849616a11b161a";
  };
in
  src
