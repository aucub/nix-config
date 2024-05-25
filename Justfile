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
  sudo nixos-rebuild switch --flake --show-trace --log-format internal-json -v .#neko |& nom --json

rsu:
  sudo nixos-rebuild switch --flake --upgrade --show-trace --log-format internal-json -v .#neko |& nom --json

rsb:
  sudo nixos-rebuild switch --install-bootloader --flake --show-trace --log-format internal-json -v .#neko |& nom --json

hs:
  home-manager switch --flake --show-trace --log-format internal-json -v .#uymi@neko |& nom --json

bp input:
  nix build --impure --show-trace --log-format internal-json -v .#{{input}} |& nom --json

############################################################################
#
#  Other useful commands
#
############################################################################

fmt:
  nix fmt  --no-write-lock-file

lg input:
  nix-locate {{input}}  | grep -v '('
