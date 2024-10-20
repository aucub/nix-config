{
  flake,
  pkgs,
  config,
  ...
}:
let
  defaultUserName = flake.config.hosts."${config.networking.hostName}".defaultUserName;
in
{
  imports = [
    ./packages.nix
    ./services.nix
    ./dae/default.nix
    # ./containers.nix
  ];

  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      flake-registry = "";
      experimental-features = [
        "nix-command"
        "flakes"
        "cgroups"
        "ca-derivations"
        "git-hashing"
        "dynamic-derivations"
      ];
      auto-optimise-store = true;
      always-allow-substitutes = true;
      builders-use-substitutes = true;
      use-cgroups = true;
      warn-dirty = false;
      fsync-metadata = false;
      substituters = [
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
        "https://cache.garnix.io"
        "https://nanari.cachix.org"
        "https://cache.ngi0.nixos.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "nanari.cachix.org-1:g2X+SmJHsI0siZez0IUUgVyOuvPG5CWhrhoE11MqALA="
        "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
      ];
      trusted-users = [ (if pkgs.stdenv.isDarwin then defaultUserName else "@wheel") ];
    };
    channel.enable = false; # nix-channel 命令和状态文件
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
