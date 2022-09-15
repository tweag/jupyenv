{pkgs}: let
  inherit
    (pkgs)
    cacert
    cmake
    fetchgit
    fetchurl
    fetchFromGitHub
    git
    glibc
    libffi
    llvm
    makeWrapper
    ncurses
    python
    stdenv
    wget
    zlib
    ;
in
  stdenv.mkDerivation rec {
    name = "cling";

    clingSrc = fetchFromGitHub {
      owner = "root-project";
      repo = "cling";
      rev = "3d789b131ae6cb41686fb799f35f8f4760eb2cea";
      sha256 = "sha256-PLXNnIehHoXfuXPIapFRXLp0+J6Jp44b5xFMideB1qs=";
    };

    clangSrc = fetchgit {
      url = "http://root.cern.ch/git/clang.git";
      rev = "7a13d39940cfd2bd1f486cb8b70a4ce09c076222"; # This is the head of the cling-patches branch
      sha256 = "sha256-x7BxgKQ9X7eocxpz1M3ncfIYjhs/TMRZOYMeEwPa4PE=";
    };

    llvmSrc = fetchgit {
      url = "http://root.cern.ch/git/llvm.git";
      rev = "cling-v0.6"; # This is the head of the cling-patches branch
      sha256 = "sha256-fVUmN+CiyQI/E+dNhue7ixEbdU9a+wwfJ2Ex53cZmno=";
    };

    srcs = [clingSrc llvmSrc clangSrc];

    unpackCmd = ''
      mkdir -p ./all
      if [[ $curSrc == *"clang"* ]]; then
        cp -r $curSrc ./all/clang
      elif [[ $curSrc == *"llvm"* ]]; then
        cp -r $curSrc ./all/llvm
      else
        cp -r $curSrc ./all/cling
      fi
    '';

    buildInputs = [python wget cacert git cmake llvm libffi makeWrapper];
    propagatedBuildInputs = [ncurses zlib];
    configurePhase = "true";

    buildPhase = ''
      mv clang llvm/tools
      mv cling llvm/tools
      mkdir -p $out
      mkdir build
      cd build
      cmake -DCMAKE_INSTALL_PREFIX=$out -DLLVM_BUILD_TOOLS=Off -DLLVM_ENABLE_FFI=ON -DLLVM_ENABLE_RTTI=ON -DLLVM_INSTALL_UTILS=ON -DCMAKE_BUILD_TYPE=Release ../llvm
      cmake --build . --config Release --target cling -j $NIX_BUILD_CORES
      cmake --build . --target install
    '';

    postFixup = ''
      wrapProgram $out/bin/cling \
      --add-flags "-idirafter ${glibc.dev}/include"
    '';
  }
