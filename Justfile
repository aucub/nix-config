set shell := ["fish", "-c"]

############################################################################
#
#  Common commands
#
############################################################################

# update all the flake inputs
up:
  nix flake update

# List all generations of the system profile
history:
  nix profile history --profile /nix/var/nix/profiles/system

# remove all generations older than 7 days
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

# Garbage collect all unused nix store entries
gc:
  sudo nix store gc --debug
  sudo nix-collect-garbage --delete-old

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

bp input:
  nix build --impure .#{{input}} --show-trace

############################################################################
#
#  Other useful commands
#
############################################################################

fmt:
  nix fmt

lg input:
  nix-locate {{input}} | grep -v '('
