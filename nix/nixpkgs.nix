let
  src = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/f0bc52214879095e03f5256d2eb35796b549c048.tar.gz";
    sha256 = "02p38pqv44i9inhskq5lmh6my3zilm21njdipv1dzms7k3mh47mn";
  };
in
  import src
