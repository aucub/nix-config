{
  flake,
  lib,
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

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") flake.inputs;
    in
    {
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
      package = pkgs.nixVersions.latest;
      settings = {
        accept-flake-config = true;
        experimental-features = [
          "nix-command"
          "flakes"
          "cgroups"
        ];
        nix-path = config.nix.nixPath;
        flake-registry = "";
        auto-optimise-store = true;
        builders-use-substitutes = true;
        use-cgroups = true;
        warn-dirty = false;
        fsync-metadata = false;
        substituters = [
          "https://mirrors.ustc.edu.cn/nix-channels/store"
          "https://nix-community.cachix.org"
          "https://cache.garnix.io"
          "https://qihaiumi.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "qihaiumi.cachix.org-1:Cf4Vm5/i3794SYj3RYlYxsGQZejcWOwC+X558LLdU6c="
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
