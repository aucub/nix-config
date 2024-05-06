{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin
        floccus
        bitwarden
        violentmonkey
        videospeed
        single-file
        user-agent-string-switcher
      ];
      settings = {
        "browser.search.region" = "CN";
        "media.ffmpeg.vaapi.enabled" = true;
        "media.ffvpx.enabled" = false;
        "gfx.webrender.all" = true;
        # Disable battery fingerprinting
        "dom.battery.enabled" = false;
        # Enable tracking protection
        "privacy.trackingprotection.enabled" = true;
        # Disable SB
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.safebrowsing.downloads.enabled" = false;
        # Don't save passwords
        "signon.rememberSignons" = false;
        # Pixiv
        "network.http.referer.XOriginPolicy" = 0;
        # Enable search suggestions
        "browser.search.suggest.enabled" = true;
        "browser.urlbar.suggest.searches" = true;
      };
    };
  };
}
