# JupyterWith Kernels

This is the root folder for JupyterWith kernels. Each kernel folder contains
documentation on how to use it.

All these kernels are available from the imported repository:

```
{
  jupyter = import (builtins.fetchGit {
    url = https://github.com/tweag/jupyterWith;
    rev = "";
  });

  kernels = jupyter.kernels;
}
```

All the examples in the subfolders suppose that `kernels` attributes are in
scope.
