{
  self,
  lib,
}: let
  /*
  Creates a nested list of kernels instances from a path, `parentPath`, and a
  prefix name list, `prefix`.

  Generally, `prefix` should be set as `[]`, an empty list, but is needed
  for recursive calls. The elements of `prefix` will be prepended to the
  `name` value of the kernel instance. E.g. `["example"]` will result in
  "example-<kernelName>" and `["lots-of-prefix"]` will result in "lots-of-
  prefix-<kernelName>".

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

  Type: Path -> [String] -> [...[<KernelInstance> | null]...]

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
  Creates a list of kernels instances from a path, `path`, and a prefix name
  list, `prefix`.

  A kernel instance is an attrset with a `name` that is constructed from the
  folder paths leading up to the kernel file. For example, if `path` is ./
  kernels with a prefix of [] and a kernel file is located in ./ kernels/
  example/python/minimal/default.nix, then the resulting `name` will be
  "example-python-minimal". Similarly, if `path` is ./kernels/example and
  `prefix` is ["example"], then the resulting `name` will be the same as
  before. The other attribute, `path`, will be that kernel file's path in the
  nix store.

  The function takes the nested list from _getKernelListFromPath, flattens it,
  removes the nulls, and removes any duplicates. However, there should never be
  duplicates.

  Type: Path -> [String] -> [<KernelInstance>]

  Example:
    getKernelAttrsetFromPath ./kernels/example ["example"]
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
  a path, `path`, and a prefix name list, `prefix`.

  Example:
    mapKernelsFromPath ./kernels/example ["example"]
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
  Creates a shell command as a string that copies kernel logo images to a path
  in the nix store.

  `kernelLogos` is an array of strings whose values should match attribute
  names in `kernelInstance` whose value is a path to a logo image file.

  If no match from `kernelLogos` is found in `kernelInstance`, the resulting
  string will be empty.

  Type: [String] -> <KernelInstance> -> String

  Example:
    let
      kernelInstance = {
        name = "pythontest";
        logo64 = ./kernels/python/logo-64x64.png;
      };
    in
      kernelLib.copyKernelLogos ["logo64"] kernelInstance
    ->
    "cp /nix/store/<hash>-logo-64x64.png $out/kernels/pythontest/logo-64x64.png\n"

  Example:
    let
      kernelInstance = {
        name = "pythontest";
        logo64 = ./kernels//python/logo-64x64.png;
      };
    in
      kernelLib.copyKernelLogos ["logo32"] kernelInstance
    ->
    ""
  */
  copyKernelLogos = kernelLogos: kernelInstance:
    builtins.concatStringsSep "\n"
    (
      builtins.map
      (
        logo: let
          kernelLogoPath = kernelInstance.${logo};
        in
          lib.optionalString (builtins.hasAttr logo kernelInstance) ''
            cp ${kernelLogoPath} $out/kernels/${kernelInstance.name}/${baseNameOf kernelLogoPath}
          ''
      )
      kernelLogos
    );

  /*
  Fixes many of the attribute names in the kernel instance attribute set in
  preparation for converting to a kernel spec JSON file for Jupyter. Jupyter
  kernel spec files have particular field names and uses snake.

  Type: [String] -> <KernelInstance> -> AttrSet

  Example:
    let
      kernelInstance = {
        name = "pythontest";
        displayName = "Python Test";
        codemirrorMode = "python";
        logo64 = ./kernels/python/logo-64x64.png;
      };
    in
      kernelLib.fixKernelJSON ["logo64" "logo32"] kernelInstance
    ->
    {
      name = "pythontest";
      display_name = "Python Test";
      codemirror_mode = "python";
      logo64 = "logo-64x64.png";
    }

  */
  createKernelSpec = kernelLogos: kernelInstance:
    lib.mapAttrs'
    (
      name: value:
        if builtins.elem name kernelLogos
        then {
          inherit name;
          value = baseNameOf value;
        }
        else if name == "displayName"
        then {
          name = "display_name";
          inherit value;
        }
        else if name == "codemirrorMode"
        then {
          name = "codemirror_mode";
          inherit value;
        }
        else {inherit name value;}
    )
    kernelInstance;

  /*
  Takes the kernel instance and copies it as the kernel spec JSON file to a
  path in the nix store.

  Type: [String] -> <KernelInstance> -> AttrSet

  Example:
    let
      kernelInstance = {
        name = "pythontest";
        displayName = "Python Test";
        codemirrorMode = "python";
        logo64 = ./kernels/python/logo-64x64.png;
      };
    in
      kernelLib.fixKernelJSON ["logo64" "logo32"] kernelInstance
    ->
    "echo '{\"codemirror_mode\":\"python\",\"display_name\":\"Python Test\",\"logo64\":\"logo-64x64.png\",\"name\":\"pythontest\"}' > $out/kernels/pythontest/kernel.json\n"
  */
  copyKernelSpec = kernelLogos: kernelInstance: let
    kernelSpec = createKernelSpec kernelLogos kernelInstance;
  in ''
    echo '${builtins.toJSON kernelSpec}' > $out/kernels/${kernelInstance.name}/kernel.json
  '';
in {
  inherit
    getKernelAttrsetFromPath
    mapKernelsFromPath
    copyKernelLogos
    createKernelSpec
    copyKernelSpec
    ;
}
