{lib}: let
  /*
  Creates a nested list of kernels instances from a path, `parentPath`, and a
  prefix name, `prefix`.

  Generally, `prefix` should be set as `[]`, an empty list, but is needed
  for recursive calls.

  A kernel instance is an attrset with a `name` that is constructed from the
  folder paths leading up to the kernel file. For example, if the function is
  called on ./kernels/example and a kernel file is located in
  ./kernels/example/python/minimal/default.nix, then the resulting `name` will
  be "example-python-minimal". The other attribute, `path`, will be that kernel
  file's path in the nix store.

  The function returns null for any file found that is not named "default.nix".
  The function should not have any duplicate attribute sets.
  The function should exhaustively and recursively search all folders.
  The function should handle kernel files (i.e. default.nix) at multiple levels.
  For example, having a kernel file in ./python and ./python/tweaked, is
  perfectly fine and will not create collisions in kernel names.

  Type: Path -> String -> [...[<KernelInstance> | null]...]

  Example:
    _getKernelListFromPath ./kernels/example ""
    =>
    [
     [
       [
         {
           "name": "example-bash-minimal",
           "path": "/nix/store/<hash>/default.nix"
         },
         null,
         null
       ]
     ],
     [
       [
         {
           "name": "example-c-minimal",
           "path": "/nix/store/<hash>/default.nix"
         },
         null,
         null
       ]
     ],
    ...
    ]
  */
  _getKernelListFromPath = parentPath: prefix:
    lib.mapAttrsToList
    (
      fileName: fileType: let
        nextPath = parentPath + "/${fileName}";
        nextName = prefix ++ [fileName];
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
          name = lib.concatStringsSep "-" prefix;
          path = defaultNixFile;
        }
        else null
    )
    (builtins.readDir parentPath);

  /*
  Creates a list of kernels instances from a path, `path`.

  A kernel instance is an attrset with a `name` that is constructed from the
  folder paths leading up to the kernel file. For example, if the function is
  called on ./kernels/example and a kernel file is located in
  ./kernels/example/python/minimal/default.nix, then the resulting `name` will
  be "example-python-minimal". The other attribute, `path`, will be that kernel
  file's path in the nix store.

  The function takes the nested list from _getKernelListFromPath, flattens it,
  removes the nulls, and removes any duplicates. However, there should never be
  duplicates.

  Type: Path -> [<KernelInstance>]

  Example:
    getKernelAttrsetFromPath ./kernels/example
    =>
    [
      {
        "name": "example-bash-minimal",
        "path": "/nix/store/<hash>/default.nix"
      },
      {
        "name": "example-c-minimal",
        "path": "/nix/store/<hash>/default.nix"
      },
    ...
    ]
  */
  getKernelAttrsetFromPath = path: prefix:
    lib.unique
    (
      lib.remove
      null
      (
        lib.flatten
        (_getKernelListFromPath path prefix)
      )
    );

  /*
  Creates an attrset that maps kernel names to their path in the nix store from
  a path, `path`.

  The function should return a unique list of kernel names that map to unique
  locations in the nix store.

  Example:
    mapKernelsFromPath ./kernels/example
    =>
    {
      "example-bash-minimal": "/nix/store/<hash>/default.nix",
      "example-c-minimal": "/nix/store/<hash>/default.nix",
    ...
    }
  */
  mapKernelsFromPath = path: prefix:
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
        (getKernelAttrsetFromPath path prefix)
      )
    );

  /*
  Creates an attrset that contains all the available and example kernels from a
  path to the kernels directory, `kernelsPath`.

  Example:
    _getKernelsFromPath (self + /kernels) ->
      {
        kernels = {
          example-bash-minimal = "/nix/store/<hash>/kernels/example/bash/minimal/default.nix";
          ...
        };
        available = {
          bash = "/nix/store/<hash>/kernels/available/bash/default.nix";
          ...
        };
      }
  */
  _getKernelsFromPath = kernelsPath: {
    kernels = mapKernelsFromPath "${kernelsPath}/example" ["example"];
    available = mapKernelsFromPath "${kernelsPath}/available" [];
  };
in {
  inherit
    _getKernelsFromPath
    getKernelAttrsetFromPath
    mapKernelsFromPath
    ;
}
