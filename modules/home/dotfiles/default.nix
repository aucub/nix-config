{ lib, ... }:
{
  xdg.configFile = {
    "fish/functions/set_proxy.fish".source = .config/fish/functions/set_proxy.fish;
    "variety/variety.conf".text = lib.generators.toINIWithGlobalSection { } {
      globalSection = {
        change_on_start = "True";
        change_enabled = "False";
        change_interval = 86400;
        internet_enabled = "True";
        wallpaper_display_mode = "smart";
      };
      sections.sources.src10 = "True|wallhaven|anime girls";
    };
  };
}
