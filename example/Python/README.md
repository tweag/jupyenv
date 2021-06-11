In this example we use [poetry2nix](https://github.com/nix-community/poetry2nix)
to make a python kernel, at expose to the jupyter, with python packages with
specified versions.

Here is how it works:

1. Make sure you have installed [poetry](https://github.com/python-poetry/poetry).

2. Specify your desired packages in `pyproject.toml` (see the example).

3. Run
```
$ poetry update
```
With this command poetry resolves the dependencies versions
and updates `poetry.lock` file with exact versions of the packages.

4. Now both files `pyproject.toml` and `poetry.lock` are ready. We only need to run
the following command to enter to the desired shell:
```
$ nix-shell
```
