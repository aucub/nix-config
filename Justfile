set shell := ["fish", "-c"]

############################################################################
#
#  Common commands
#
############################################################################

bp input:
  nix build --impure .#{{input}} --show-trace

############################################################################
#
#  NixOS related commands
#
############################################################################

rs:
  sudo nixos-rebuild switch --flake .#neko --show-trace

rsu:
  sudo nixos-rebuild switch --flake .#neko --upgrade --show-trace

rsb:
  sudo nixos-rebuild switch  --flake .#neko --install-bootloader --show-trace

hs:
  home-manager switch --flake .#uymi@neko --show-trace

############################################################################
#
#  Other useful commands
#
############################################################################

# update all the flake inputs
up:
  nix flake update

fmt:
  nix fmt

lg input:
  nix-locate {{input}} | grep -v '('
