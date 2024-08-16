{ ... }:
{
  services.dae = {
    enable = true;
    configFile = "/etc/dae/config.dae";
  };
  environment.etc.dae-config = {
    target = "dae/config.dae";
    source = ./config.dae;
    mode = "0640";
  };
  systemd.services.dae.serviceConfig.LoadCredential = [
    "extra-config.dae:/etc/dae/extra-config.dae"
  ];
}
