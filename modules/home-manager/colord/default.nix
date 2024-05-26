{config, ...}: {
  home.file.".local/share/icc/default.icc".source = ./default.icc;

  systemd.services.load-icc-profile = {
    description = "Load ICC profile";
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "oneshot";
    script = ''
      colormgr import-profile ${HOME}/.local/share/icc/default.icc
      device_id=$(colormgr get-devices | grep "Device ID:" | cut -d ':' -f 2- | xargs)
      colormgr device-add-profile $device_id ${HOME}/.local/share/icc/default.icc
      colormgr set-default-device-profile $device_id
    '';
  };
}
