#!/usr/bin/env bash
echo "Jupyter version: $(nix-shell --pure -A shell --command 'jupyter --version')"
