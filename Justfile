set shell := ["fish", "-c"]

############################################################################
#
#  Common commands
#
############################################################################

bp input:
  nix build --impure .#{{input}} --show-trace --print-build-logs --verbose

############################################################################
#
#  NixOS related commands
#
############################################################################

rs:
  sudo nixos-rebuild switch --flake .#neko --no-build-nix --show-trace --print-build-logs --verbose

rsu:
  sudo nixos-rebuild switch --flake .#neko --upgrade --no-build-nix --show-trace --print-build-logs --verbose

rsb:
  sudo nixos-rebuild switch  --flake .#neko --install-bootloader --no-build-nix --show-trace --print-build-logs --verbose

rsr:
  sudo nixos-rebuild switch --flake .#neko --rollback --show-trace --print-build-logs --verbose

hs:
  home-manager switch --flake .#uymi@neko --show-trace --print-build-logs --verbose

############################################################################
#
#  Other useful commands
#
############################################################################

up:
  nix flake update

fmt:
  nix fmt

lg input:
  nix-locate {{input}} | grep -v '('
