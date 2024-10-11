hostname := "neko"
username := "uymi"

# Default command when 'just' is run without arguments
default:
  @just --list

############################################################################
#
#  Common commands
#
############################################################################

build target:
    nix build .#{{ target }} --impure --show-trace -L -v --accept-flake-config

build-os:
    @just build nixosConfigurations.{{ hostname }}.config.system.build.toplevel

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
    nix eval .#homeConfigurations.{{ username }}.config.{{ target }} --impure --show-trace -L -v

switch-hm:
    home-manager switch --flake .#{{ username }} --impure --show-trace -L -v

############################################################################
#
#  Other useful commands
#
############################################################################

# Update nix flake
update:
  nix flake update

# Format nix files
fmt:
  nix fmt --show-trace -L -v

# Check nix flake
check:
  nix flake check --no-build --impure --show-trace -L -v