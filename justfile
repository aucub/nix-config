set-proxy-env := "env ftp_proxy=\"${ftp_proxy:-}\" all_proxy=\"${all_proxy:-}\" FTP_PROXY=\"${FTP_PROXY:-}\" http_proxy=\"${http_proxy:-}\" HTTPS_PROXY=\"${HTTPS_PROXY:-}\" https_proxy=\"${https_proxy:-}\" ALL_PROXY=\"${ALL_PROXY:-}\" HTTP_PROXY=\"${HTTP_PROXY:-}\""

hostname := "neko"

username := "uymi"

############################################################################
#
#  Common commands
#
############################################################################

build target:
  nix build .#{{target}} --show-trace --impure -L -v

############################################################################
#
#  NixOS related commands
#
############################################################################

check:
  nix flake check --impure --show-trace -L -v

switch:
  sudo {{set-proxy-env}} nixos-rebuild switch --flake .#{{hostname}} --no-build-nix --show-trace -L -v

switch-boot:
  sudo {{set-proxy-env}} nixos-rebuild switch  --flake .#{{hostname}} --install-bootloader --no-build-nix --show-trace -L -v

build-os:
  nix build .#nixosConfigurations.{{hostname}}.config.system.build.toplevel --impure --show-trace -L -v

eval target:
  nix eval .#nixosConfigurations.{{hostname}}.config.{{target}} --impure --show-trace -L -v

eval-hm target:
  nix eval .#homeConfigurations.{{username}}@{{hostname}}.config.{{target}} --impure --show-trace -L -v

hm-switch:
  home-manager switch --flake .#{{username}}@{{hostname}} --show-trace -L -v

############################################################################
#
#  Other useful commands
#
############################################################################

update:
  nix flake update

fmt:
  nix fmt --show-trace -L -v
