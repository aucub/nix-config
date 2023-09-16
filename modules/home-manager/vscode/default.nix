{ pkgs, config, lib, ... }:

{
  home.file.".config/Code/User/settings.json".source = ./settings.json;
  home.file.".config/Code/User/settings.json-bak".source = ./settings.json;
  home.activation.removeExistingVSCodeProfile =
    lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      rm -f "${config.xdg.configHome}/Code/User/settings.json"
    '';
}
