set shell := ["fish", "-c"]

############################################################################
#
#  Common commands
#
############################################################################

# update all the flake inputs
up:
  nix flake update

# Update specific input
# Usage: just upp nixpkgs
upp input:
  nix flake update {{input}}

# List all generations of the system profile
history:
  nix profile history --profile /nix/var/nix/profiles/system

# Open a nix shell with the flake
repl:
  nix repl -f flake:nixpkgs

# remove all generations older than 7 days
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

# Garbage collect all unused nix store entries
gc:
  # garbage collect all unused nix store entries
  sudo nix store gc --debug
  sudo nix-collect-garbage --delete-old

# Remove all reflog entries and prune unreachable objects
gitgc:
  git reflog expire --expire-unreachable=now --all
  git gc --prune=now

############################################################################
#
#  NixOS Desktop related commands
#
############################################################################

rs:
  sudo nixos-rebuild switch --flake .#neko

rsu:
  sudo nixos-rebuild switch --flake --upgrade .#neko

rsb:
  sudo nixos-rebuild switch --install-bootloader --flake .#neko

hs:
  home-manager switch --flake .#uymi@neko

bp input:
  nix build .#{{input}}

############################################################################
#
#  Other useful commands
#
############################################################################

fmt:
  # format the nix files in this repo
  nix fmt  --no-write-lock-file

path:
  $env.PATH | split row ":"

wd:
  nix-store --gc --print-roots | rga -v '/proc/' | rga -Po '(?<= -> ).*' | xargs -o nix-tree

lg input:
  nix-locate {{input}}  | grep -v '('
