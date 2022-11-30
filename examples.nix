{lib}: let
  getKernelListFromPath = parentPath: prevName:
    lib.mapAttrsToList
    (
      fileName: fileType: let
        parentString = builtins.toString parentPath;
        parentDir = lib.last (lib.splitString "/" parentString);

        nextPath = parentPath + "/${fileName}";
        nextName =
          if prevName == ""
          then parentDir
          else (prevName + "-" + parentDir);

        nextLevel = getKernelListFromPath nextPath nextName;
        defaultNixFile = "${parentPath}/default.nix";
      in
        if
          (fileType == "directory")
          && !lib.hasPrefix "_" fileName
        then nextLevel
        else if
          (fileType == "regular")
          && lib.pathExists defaultNixFile
        then {
          name = nextName;
          value = defaultNixFile;
        }
        else null
    )
    (builtins.readDir parentPath);

  getKernelAttrsetFromPath = path: (
    builtins.listToAttrs (
      lib.remove
      null
      (
        lib.flatten
        (getKernelListFromPath path "")
      )
    )
  );
in {
  inherit getKernelAttrsetFromPath;
}
