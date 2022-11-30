let
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;

  mapKernelsFromPath = parentName: parentPath:
  #builtins.listToAttrs
  (
    builtins.mapAttrs
    (
      {
        name,
        value,
      }: {
        inherit name;
        value = value;
        # path = parentPath + "/${name}";
        # blah = lib.filesystem.listFilesRecursive (builtins.toPath path / name);
      }
    )
    (getKernelAttrsetFromPath parentPath)
  );

  filterValidKernelPaths = parentPath: parentName: fileName: fileType: let
    defaultFilePath = "${parentPath}/${parentName}/${fileName}/default.nix";
  in
    if
      (fileType == "directory")
      && !lib.pathExists defaultFilePath
    then let
      # subAttr = mapKernelsFromPath fileName (parentPath + "/${fileName}");
      subAttr = getKernelAttrsetFromPath (parentPath + "/${parentName}") fileName;
    in
      # builtins.trace (subAttr // {inherit parentPath parentName fileName;})
      {
        # name = fileName;# + "-" + subAttr.name;
        name = parentName + "-" + fileName + "-bar";
        value = subAttr;
      }
    else if
      (fileType == "directory")
      && lib.pathExists defaultFilePath
    then {
      name = fileName;
      # name = parentName + "-" + fileName + "-foo";
      value = defaultFilePath;
    }
    else {
      name = "null";
      value = "null";
    };

  getKernelAttrsetFromPath = parentPath: parentName:
    lib.mapAttrsToList
    (filterValidKernelPaths parentPath parentName)
    (builtins.readDir (parentPath + "/${parentName}"));

  getKernels = parentPath: parentName:
    lib.mapAttrsToList
    (
      fileName: fileType: let
        parentString = builtins.toString parentPath;
        parentDir = lib.last (lib.splitString "/" parentString);
        # subPath = getKernels (parentPath + "/${fileName}") parentDir;

        nextPath = parentPath + "/${fileName}";
        nextName =
          if parentName == ""
          then parentDir
          else (parentName + "-" + parentDir);

        nextLevel = getKernels nextPath nextName;
        defaultNixFile = "${parentPath}/default.nix";
      in
        if
          (fileType == "directory")
          && !lib.hasPrefix "_" fileName
        then nextLevel
        #{
        #  # name = parentName;
        #  name = nextName + "-" + fileName;
        #  value = subPath;
        #}
        else if
          (fileType == "regular")
          && lib.pathExists defaultNixFile
        then {
          #name = fileName;
          #value = fileType;
          name = nextName;
          value = defaultNixFile;
        }
        else null
    )
    (builtins.readDir parentPath);

  getKernelAttrset = path: (
    builtins.listToAttrs (
      lib.remove
      null
      (
        lib.flatten
        (getKernels path "")
      )
    )
  );
in
  # builtins.readDir ./kernels/example
  # getKernelAttrsetFromPath ./kernels "example"
  # mapKernelsFromPath "example" ./kernels/example
  # mapKernelsFromPath "example" ./kernels
  # (builtins.readDir ./kernels/example)
  # getKernels ./kernels/example
  #lib.remove null (lib.flatten (getKernels ./kernels/example ""))
  getKernelAttrset ./kernels/example
