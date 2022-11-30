{lib}: let
  _getKernelListFromPath = parentPath: prevName:
    lib.mapAttrsToList
    (
      fileName: fileType: let
        parentDir =
          builtins.unsafeDiscardStringContext
          (builtins.baseNameOf parentPath);

        nextPath = parentPath + "/${fileName}";
        nextName =
          if prevName == ""
          then parentDir
          else (prevName + "-" + parentDir);

        nextLevel = _getKernelListFromPath nextPath nextName;
        defaultNixFile = "${parentPath}/default.nix";
      in
        if
          (fileType == "directory")
          && !lib.hasPrefix "_" fileName
        then nextLevel
        else if
          (fileType == "regular")
          && lib.pathExists defaultNixFile
          && lib.hasSuffix ".nix" fileName
          && !lib.hasPrefix "_" fileName
        then {
          name = nextName;
          path = defaultNixFile;
        }
        else null
    )
    (builtins.readDir parentPath);

  getKernelAttrsetFromPath = path:
    lib.unique
    (
      lib.remove
      null
      (
        lib.flatten
        (_getKernelListFromPath path "")
      )
    );

  mapKernelsFromPath = path:
    lib.optionalAttrs
    (lib.pathExists path)
    (
      builtins.listToAttrs
      (
        builtins.map
        (
          {
            name,
            path,
          }: {
            inherit name;
            value = path;
          }
        )
        (getKernelAttrsetFromPath path)
      )
    );
in {
  inherit
    getKernelAttrsetFromPath
    mapKernelsFromPath
    ;
}
