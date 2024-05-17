install
```bash
export NIX_CONFIG="experimental-features = nix-command flakes"
nixos-generate-config --root /mnt
nixos-install --flake .#conch
nixos-install --option substituters "https://mirrors.bfsu.edu.cn/nix-channels/store" --flake .#conch
```
rebuild
```bash
nixos-rebuild switch --install-bootloader --flake .#conch
home-manager switch --flake .#scorer@conch
```
build package
```bash
nix build .#example
```