#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nixVersions.latest just

export NIX_CONFIG="experimental-features = nix-command flakes cgroups ca-derivations git-hashing dynamic-derivations"

just install
# NIX_PATH="nixpkgs=/nix/store" just install
