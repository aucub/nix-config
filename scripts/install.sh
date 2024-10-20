#!/bin/sh

set -e

export NIX_CONFIG="experimental-features = nix-command flakes cgroups ca-derivations git-hashing dynamic-derivations"

nixos-install --option extra-substituters "https://mirrors.ustc.edu.cn/nix-channels/store https://cache.nixos.org https://nix-community.cachix.org https://cache.garnix.io https://cache.ngi0.nixos.org" --option trusted-public-keys "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g= cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA=" --flake .#neko --no-root-passwd --accept-flake-config --impure --show-trace -L -v
# NIX_PATH="nixpkgs=/nix/store" nixos-install --flake .#neko --no-root-passwd
