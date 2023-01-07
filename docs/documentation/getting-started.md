## Setup


a) Install [Nix](https://nixos.org/download.html#nix-install-linux)

=== "Linux"

    ```
    sh <(curl -L https://nixos.org/nix/install) --daemon
    ```

=== "macOS"

    ```
    sh <(curl -L https://nixos.org/nix/install)
    ```

=== "Windows (WSL2)"

    ```
    sh <(curl -L https://nixos.org/nix/install) --no-daemon
    ```

=== "Docker"

    ```
    docker run -it nixos/nix
    ```

b) Enable `nix command` and `flakes`. See the [Wiki](https://nixos.wiki/wiki/Flakes#Enable_flakes).

=== "Newcomers"

    ```bash
    # ~/.config/nix/nix.conf
    experimental-features = nix-command flakes
    ```

=== "configuration.nix"

    ```nix
    # /etc/nixos/configuration.nix
    { pkgs, ... }: {
      ...
      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      ...
    }
    ```


## Quick Start

The following snippet will create a new project directory, initialize the project with a flake template, enable a Python kernel, and start the JupyterLab environment.

```shell
mkdir my-project
cd my-project
nix flake init --template github:tweag/jupyterWith
nix run
```

After some time, you should see the following in your terminal.
Your default web browser should open and enter the JupyterLab environment.
If it does not, use one of the suggested URLs.

```shell
...
[I 2022-10-11 18:47:30.346 ServerApp] Jupyter Server 1.17.1 is running at:
[I 2022-10-11 18:47:30.346 ServerApp] http://localhost:8888/lab?token=8f2261a45601848bd79eda97d8d39c3d0f4978bc61fbe346
[I 2022-10-11 18:47:30.346 ServerApp]  or http://127.0.0.1:8888/lab?token=8f2261a45601848bd79eda97d8d39c3d0f4978bc61fbe346
[I 2022-10-11 18:47:30.346 ServerApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 2022-10-11 18:47:30.359 ServerApp]

    To access the server, open this file in a browser:
        file:///home/bakerdn/.local/share/jupyter/runtime/jpserver-286971-open.html
    Or copy and paste one of these URLs:
        http://localhost:8888/lab?token=8f2261a45601848bd79eda97d8d39c3d0f4978bc61fbe346
     or http://127.0.0.1:8888/lab?token=8f2261a45601848bd79eda97d8d39c3d0f4978bc61fbe346
```

For further instructions about the environment, kernels, and extensions, see the [How To](how-to.md) and [Tutorials](tutorials.md).
