{
  pkgs,
  config,
  lib,
  ...
}:
{
  virtualisation = {
    cri-o.storageDriver = lib.mkIf config.fileSystems."/".fsType == "btrfs" "btrfs";
    containers.enable = true;
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
      autoPrune.enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    podman-tui
    podman-compose
  ];
}
