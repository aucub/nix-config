hostname := "neko"
username := "uymi"

default:
  @just --list

build target:
    nix build .#{{ target }} --impure --show-trace -L -v

build-os:
    nixos-rebuild-ng build --flake .#{{ hostname }} --impure --show-trace -L -v

switch:
    sudo nixos-rebuild-ng switch --flake .#{{ hostname }} --impure --show-trace -L -v

switch-hm:
    home-manager switch --flake .#{{ username }} --impure --show-trace -L -v

eval target:
    nix eval .#nixosConfigurations.{{ hostname }}.config.{{ target }} --impure --show-trace -L -v

eval-hm target:
    nix eval .#homeConfigurations.{{ username }}.config.{{ target }} --impure --show-trace -L -v

install:
    nixos-install --flake .#{{ hostname }} --no-root-passwd --accept-flake-config --impure --show-trace -L -v

update:
  nix flake update

fmt:
  nix fmt --show-trace -L

check:
  nix flake check --impure --show-trace -L
