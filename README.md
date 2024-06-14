install
```bash
export NIX_CONFIG="experimental-features = nix-command flakes"
nixos-generate-config --root /mnt
nixos-install  --option substituters "https://mirrors.ustc.edu.cn/nix-channels/store https://cache.nixos.org https://nix-community.cachix.org https://nixpkgs-wayland.cachix.org https://qihaiumi.cachix.org https://cosmic.cachix.org https://nyx.chaotic.cx" --option trusted-public-keys "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA= qihaiumi.cachix.org-1:Cf4Vm5/i3794SYj3RYlYxsGQZejcWOwC+X558LLdU6c= cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE= chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8=" --flake .#neko --no-root-passwd
```
NIX_PATH="nixpkgs=/nix/store" nixos-install --flake .#neko --no-root-passwd