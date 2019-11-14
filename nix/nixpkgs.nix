let
  src = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/db3beda6b56563777254156351b9bed349cf7d07.tar.gz";
    sha256 = "0lkxj9pkzwxbihn3j5nyk61814m5kshpziagdzicxlns1gn1295i";
  };
in
  import src
