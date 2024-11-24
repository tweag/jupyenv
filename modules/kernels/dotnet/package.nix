{
  lib,
  buildDotnetGlobalTool,
  dotnetCorePackages,
  zlib,
  openssl,
}: let
  inherit (dotnetCorePackages) sdk_8_0;
in
  buildDotnetGlobalTool rec {
    pname = "Microsoft.dotnet-interactive";
    version = "1.0.556801";

    nugetSha256 = "sha256-tABt/DltggX85SZaaZK7ZP+L3EqxEh0fZ1pfB4MOtxk=";

    dotnet-sdk = sdk_8_0;
    dotnet-runtime = sdk_8_0;
    executables = "dotnet-interactive";
    runtimeDeps = [
      zlib
      openssl
    ];
    meta = with lib; {
      description = ".NET Interactive";
      mainProgram = "dotnet-interactive";
      homepage = "https://github.com/dotnet/interactive";
      changelog = "https://github.com/dotnet/interactive/releases/tag/v${version}";
      license = licenses.mit;
      platforms = platforms.linux ++ platforms.windows ++ platforms.darwin;
      maintainers = with maintainers; [anpin];
    };
  }
