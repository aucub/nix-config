set shell := ["fish", "-c"]

############################################################################
#
#  Common commands
#
############################################################################

bp input:
  nix build .#{{input}} --show-trace --impure -L -v

############################################################################
#
#  NixOS related commands
#
############################################################################

rs:
  sudo nixos-rebuild switch --flake .#neko --no-build-nix --show-trace -L -v

rsu:
  sudo nixos-rebuild switch --flake .#neko --upgrade --no-build-nix --show-trace -L -v

rsb:
  sudo nixos-rebuild switch  --flake .#neko --install-bootloader --no-build-nix --show-trace -L -v

rsr:
  sudo nixos-rebuild switch --flake .#neko --rollback --show-trace -L -v

hs:
  home-manager switch --flake .#uymi@neko --show-trace -L -v

############################################################################
#
#  Other useful commands
#
############################################################################

up:
  nix flake update

fmt:
  nix fmt --show-trace -L -v

lg input:
  nix-locate {{input}} | grep -v '('
