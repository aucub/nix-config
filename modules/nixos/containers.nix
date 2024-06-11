{pkgs, ...}: {
  virtualisation = {
    containers = {
      enable = true;
      containersConf.settings.containers.runtime = "youki";
    };
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      networkSocket.enable = true;
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
