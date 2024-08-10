{ pkgs, config, ... }:
{
  virtualisation = {
    cri-o.storageDriver =
      if config.fileSystems."/".fsType == "btrfs" then
        "btrfs"
      else
        config.virtualisation.cri-o.storageDriver;
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
