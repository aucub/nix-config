install
```bash
export NIX_CONFIG="experimental-features = nix-command flakes"
nixos-generate-config --root /mnt
nixos-install --flake .#conch --no-root-passwd
nixos-install --option substituters "https://mirrors.ustc.edu.cn/nix-channels/store" --flake .#conch --no-root-passwd
```
rebuild
```bash
nixos-rebuild switch --install-bootloader --flake .#conch
home-manager switch --flake .#conch
```
build package
```bash
nix build .#example
```