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
  sudo nixos-rebuild switch --flake .#neko --show-trace --no-write-lock-file

rsu:
  sudo nixos-rebuild switch --flake .#neko --upgrade --show-trace --no-write-lock-file

rsb:
  sudo nixos-rebuild switch  --flake .#neko --install-bootloader --show-trace --no-write-lock-file

hs:
  home-manager switch --flake .#uymi@neko --show-trace --no-write-lock-file

bp input:
  nix build --impure .#{{input}} --show-trace --no-write-lock-file

############################################################################
#
#  Other useful commands
#
############################################################################

fmt:
  nix fmt --no-write-lock-file

lg input:
  nix-locate {{input}} | grep -v '('
