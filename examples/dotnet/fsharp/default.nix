{
  self,
  system,
  pkgs,
  ...
}: {
  kernel.dotnet.fsharp-example = {
    enable = true;
    language = "fsharp";
  };
}
