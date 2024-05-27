{
  config,
  pkgs,
  ...
}: let
  homeDir = builtins.getEnv "HOME";
in {
  home.file.".local/share/icc/default.icc".source = ./default.icc;

  systemd.user.services.load-icc-profile = {
    Unit = {
      Description = "Load ICC profile";
    };

    Service = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.colord}/bin/colormgr import-profile ${homeDir}/.local/share/icc/default.icc &&
        ${pkgs.colord}/bin/colormgr device-add-profile $( ${pkgs.colord}/bin/colormgr get-devices | grep 'Device ID:' | cut -d ':' -f 2- | xargs) ${homeDir}/.local/share/icc/default.icc &&
        ${pkgs.colord}/bin/colormgr set-default-device-profile $( ${pkgs.colord}/bin/colormgr get-devices | grep 'Device ID:' | cut -d ':' -f 2- | xargs)
      '';
    };
  };
}
