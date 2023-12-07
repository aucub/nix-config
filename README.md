# Nix Config

## Getting started

To get started with NixOS, follow these steps:

1. Enable the experimental `flakes` and `nix-command` features by running the following command:

```bash
export NIX_CONFIG="experimental-features = nix-command flakes"
```

2. Format the partition where you want to install NixOS.

3. Mount the formatted partition.

4. Generate a basic configuration for NixOS by running the following command:

```bash
nixos-generate-config --root /mnt
```

5. Copy the generated `hardware-configuration.nix` file in `/mnt/etc/nixos`.

## Usage

To apply your system configuration:

```bash
sudo nixos-rebuild switch --install-bootloader --flake .#hostname
```

If you are still on a live installation medium, you can use the following command:

```bash
sudo nixos-install --flake .#hostname
```

If you need to specify a source for package downloads, you can use the following command:

```bash
nixos-install --option substituters "https://mirrors.bfsu.edu.cn/nix-channels/store" --no-root-passwd --flake .#hostname
```

To apply your home configuration:

```bash
home-manager switch --flake .#username@hostname
```

If you don't have home-manager installed, you can try installing it using the following command:

```bash
nix shell nixpkgs#home-manager
```
