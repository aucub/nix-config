{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    extensions = with pkgs.firefox-addons; [ ublock-origin ];
  };
}
