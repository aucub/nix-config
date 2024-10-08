set-proxy-env := "env ftp_proxy=\"${ftp_proxy:-}\" all_proxy=\"${all_proxy:-}\" FTP_PROXY=\"${FTP_PROXY:-}\" http_proxy=\"${http_proxy:-}\" HTTPS_PROXY=\"${HTTPS_PROXY:-}\" https_proxy=\"${https_proxy:-}\" ALL_PROXY=\"${ALL_PROXY:-}\" HTTP_PROXY=\"${HTTP_PROXY:-}\""
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
    sudo {{ set-proxy-env }} nixos-rebuild switch --flake .#{{ hostname }} --no-build-nix --impure --show-trace -L -v

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

# Lint nix files
lint:
  nix fmt --show-trace -L -v

# Check nix flake
check:
  nix flake check --no-build --impure --show-trace -L -v