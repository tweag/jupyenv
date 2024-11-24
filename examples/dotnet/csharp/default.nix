{
  self,
  system,
  pkgs,
  ...
}: {
  kernel.dotnet.csharp-example = {
    enable = true;
  };
}
