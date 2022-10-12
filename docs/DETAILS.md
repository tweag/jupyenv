## Conventions, Structure & Terminology

To try and bridge the knowledge gap between the developers and our users, this section will discuss conventions used, kernel file structure, and terminology used to describe different stages of kernel creation. The goal is to empower you to be comfortable with modifying and extending the template files and minimize confusion in the following sections.

### What is a kernel and where is it located?

As previously mentioned, in the top level README, all kernels are located in the `kernels` directory. A kernel file located in the `kernels` directory can have virtually any name as long as it has a `.nix` file suffix. These are all valid kernel file names: `python.nix`, `go.nix`, and `my-custom-kernel.nix`.

When creating a custom kernel, it may be necessary to put the kernel file along with any supporting files, in its own directory in the `kernels` directory. For example, you can create a directory, `my-kernel`, in the `kernels` directory like so: `kernels/my-kernel/`. In `my-kernel`, your kernel file _must_ be named `default.nix`. This is a standard practice in the Nix ecosystem to make finding files easy and unabiguous.

One last note is that you can disable kernels by prefixing the kernel file or directory with an underscore. For example, if we modified the previous examples to be `_python.nix` or `_my-kernel/default.nix`, then those kernels would not be built into the JupyterLab environment and you will not see them when using the JupyterLab Web UI. This is the recommended way of temporarily hiding kernels from your environment without having to delete them. We will generally refer to kernels without the underscore prefix as enabled and kernels with the underscore prefix as disabled.

### Kernel definitions and structure

Below are some definitions we will use to minimize ambiguity and confusion in the following sections. There is no need to memorize these definitions now and we recommend skipping below to the example of a kernel file and referring back to these definitions as needed.

- available kernel: This is synonymous with a kernel file. It is a function that takes an attribute set as an argument. The applied attribute set must contain `self` and `pkgs`, and there are additional keys, such as `name` and `displayName`, that may be optionally provided.
- kernel instance: This is the available kernel with its argument applied. It returns an attribute set that is similar in structure and naming to Jupyter's kernelspec.
- kernel derivation: This is the kernel instance after being processed using internal functions. It creates a derivation that lives in the Nix store and is provided to the JupyterLab instance as an available kernel.

Below is an minimal example of how every kernel is structured. This is what you would see if you opened a kernel file (e.g. `python.nix` or `default.nix`) and what we refer to as an available kernel. In the attribute set argument, `self` and `pkgs` are required and all other keys are optional. Note that there is no actual key named `extraArgs`; this is a catchall for any and all optional keys. The optional arguments for every available kernel is unique, and rather than discuss all the possibilities, `extraArgs` is used to denote that extra arguments exist.

When extending or customizing a kernel, the `override` function can be used to modify the keys of the available kernel attribute set. Here is where you would add or modify kernel dependencies, libraries, and packages to customize the kernel to your needs. There is an example of this [above](#extending-kernels).

The available kernel is responsible for building and providing the kernel environment, `kernelEnv`, and providing that to the kernel instance. The kernel environment is what interfaces with Jupyter and handles the code the user wants to run. How each kernel environment is created is unique to each kernel and not the focus of this readme. `kernelEnv` is not actually set to `"DEEP MAGIC"` but if you want to see the deep magic, open a kernel files to see how they are built.

The kernel instance is the resulting attribute set and the fields are used to create the `kernel.json` file that Jupyter uses.

```nix
{
  self,
  pkgs,
  extraArgs ? extraArgsDefaults,
}: let
  kernelEnv = "DEEP MAGIC";
in
  {
    name = "unique kernel name";
    displayName = "pretty kernel name";
    language = "language name";
    argv = [
      "${kernelEnv}"
      "arguments"
      "to"
      "pass"
      "to"
      "jupyter"
    ];
    codemirrorMode = "language mode";
    logo32 = ./logo32.png;
    logo64 = ./logo64.png;
  }
```
