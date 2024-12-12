#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nixVersions.latest go-task

export NIX_CONFIG="experimental-features = nix-command flakes cgroups ca-derivations git-hashing dynamic-derivations"

task install
# NIX_PATH="nixpkgs=/nix/store" task install
