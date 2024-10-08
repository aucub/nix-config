{ ... }:
{
  services.dae = {
    enable = true;
    configFile = "/etc/dae/config.dae";
  };
  environment.etc.dae-config = {
    target = "dae/config.dae";
    source = ./config.dae;
  };
  systemd.services.dae.serviceConfig.LoadCredential = [
    "extra-config.dae:/etc/dae/extra-config.dae"
  ];
}
