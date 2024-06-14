{ pkgs, config, ... }:
{
  virtualisation = {
    cri-o = {
      runtime = "youki";
      storageDriver = if config.fileSystems."/".fsType == "btrfs" then "btrfs" else "overlay";
    };
    containers = {
      enable = true;
      containersConf.settings.containers.runtime = "youki";
    };
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
      autoPrune.enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    podman-tui
    podman-compose
    youki
  ];
}
