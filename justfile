hostname := "neko"
username := "uymi"

default:
    @just --list

############################################################################
#
#  Common commands
#
############################################################################

build target:
    nix build .#{{ target }} --impure --show-trace -L -v

build-os:
    @just build nixosConfigurations.{{ hostname }}.config.system.build.toplevel

build-os-etc:
    @just build nixosConfigurations.{{ hostname }}.config.system.build.etc

build-os-kernel:
    @just build nixosConfigurations.{{ hostname }}.config.system.build.kernel

############################################################################
#
#  NixOS related commands
#
############################################################################

switch:
    sudo nixos-rebuild switch --flake .#{{ hostname }} --no-build-nix --impure --show-trace -L -v

eval target:
    nix eval .#nixosConfigurations.{{ hostname }}.config.{{ target }} --impure --show-trace -L -v

eval-hm target:
    nix eval .#homeConfigurations.{{ username }}@{{ hostname }}.config.{{ target }} --impure --show-trace -L -v

switch-hm:
    home-manager switch --flake .#{{ username }}@{{ hostname }} --impure --show-trace -L -v

############################################################################
#
#  Other useful commands
#
############################################################################

update:
    nix flake update

fmt:
    nix fmt --show-trace -L -v

check:
    nix flake check --no-build --impure --show-trace -L -v
