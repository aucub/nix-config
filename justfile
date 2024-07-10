set shell := ["fish", "-c"]

set-proxy-env := "env ftp_proxy=\"$ftp_proxy\" all_proxy=\"$all_proxy\" FTP_PROXY=\"$FTP_PROXY\" http_proxy=\"$http_proxy\" HTTPS_PROXY=\"$HTTPS_PROXY\" https_proxy=\"$https_proxy\" ALL_PROXY=\"$ALL_PROXY\" HTTP_PROXY=\"$HTTP_PROXY\""

############################################################################
#
#  Common commands
#
############################################################################

bp input:
  NIXPKGS_ALLOW_UNFREE=1 nix build .#{{input}} --show-trace --impure -L -v

############################################################################
#
#  NixOS related commands
#
############################################################################

ck:
  nix flake check --impure --show-trace -L -v

rs:
  sudo {{set-proxy-env}} nixos-rebuild switch --flake .#neko --no-build-nix --show-trace -L -v

rsu:
  sudo {{set-proxy-env}} nixos-rebuild switch --flake .#neko --upgrade --no-build-nix --show-trace -L -v

rsb:
  sudo {{set-proxy-env}} nixos-rebuild switch  --flake .#neko --install-bootloader --no-build-nix --show-trace -L -v

rsr:
  sudo {{set-proxy-env}} nixos-rebuild switch --flake .#neko --rollback --show-trace -L -v

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
