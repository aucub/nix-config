```bash
export NIX_CONFIG="experimental-features = nix-command flakes"
nixos-generate-config --root /mnt
nixos-install --flake .#hostname
nixos-install --option substituters "https://mirrors.bfsu.edu.cn/nix-channels/store" --no-root-passwd --flake .#hostname
```

```bash
nixos-rebuild switch --install-bootloader --flake .#hostname
```
```bash
home-manager switch --flake .#username@hostname
```
```bash
nix shell nixpkgs#home-manager
```
