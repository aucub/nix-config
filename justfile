hostname := "neko"
username := "uymi"

default:
  @just --list

############################################################################
#
#  Common commands
#
############################################################################

build target i='':
    nix build .#{{ target }} --impure --show-trace -L -v {{ i }}

build-os i='':
    @just build nixosConfigurations.{{ hostname }}.config.system.build.toplevel {{ i }}

build-os-kernel i='':
    @just build nixosConfigurations.{{ hostname }}.config.system.build.kernel {{ i }}

############################################################################
#
#  NixOS related commands
#
############################################################################

switch i='':
    sudo nixos-rebuild switch --flake .#{{ hostname }} --no-build-nix --impure --show-trace -L -v {{ i }}

eval target:
    nix eval .#nixosConfigurations.{{ hostname }}.config.{{ target }} --impure --show-trace -L -v

eval-hm target:
    nix eval .#homeConfigurations.{{ username }}.config.{{ target }} --impure --show-trace -L -v

switch-hm i='':
    home-manager switch --flake .#{{ username }} --impure --show-trace -L -v {{ i }}

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