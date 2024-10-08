{ pkgs, ... }:
let
  cursorname = "Bibata-Modern-Classic";
  cursorpackage = pkgs: pkgs.bibata-cursors;
  cursorsize = 24;
in
{
  home = {
    pointerCursor = {
      name = cursorname;
      package = cursorpackage pkgs;
      size = cursorsize;
      gtk.enable = true;
      x11 = {
        enable = true;
        defaultCursor = cursorname;
      };
    };
    language.base = "zh_CN.UTF-8";
  };

  gtk.cursorTheme = {
    name = cursorname;
    size = cursorsize;
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      templates = null;
      publicShare = null;
      desktop = null;
    };
    mimeApps = {
      enable = true;
      defaultApplications =
        let
          browser = [ "firefox.desktop" ];
          image = [ "org.gnome.Loupe.desktop" ];
        in
        {
          "text/html" = browser;
          "application/pdf" = browser;
          "x-scheme-handler/http" = browser;
          "x-scheme-handler/https" = browser;
          "image/jpeg" = image;
          "image/png" = image;
          "image/gif" = image;
          "image/webp" = image;
          "image/tiff" = image;
          "image/bmp" = image;
          "image/vnd-ms.dds" = image;
          "image/vnd.microsoft.icon" = image;
          "image/vnd.radiance" = image;
          "image/x-exr" = image;
          "image/x-dds" = image;
          "image/x-tga" = image;
          "image/x-portable-bitmap" = image;
          "image/x-portable-graymap" = image;
          "image/x-portable-pixmap" = image;
          "image/x-portable-anymap" = image;
          "image/x-qoi" = image;
          "image/svg+xml" = image;
          "image/svg+xml-compressed" = image;
          "image/avif" = image;
          "image/heic" = image;
          "image/jxl" = image;
        };
      associations.removed = {
        "application/x-zerosize" = "org.gnome.TextEditor.desktop";
        "x-content/unix-software" = "nautilus-autorun-software.desktop";
        "x-scheme-handler/unknown" = "chromium-browser.desktop";
        "x-scheme-handler/mailto" = "chromium-browser.desktop";
        "x-scheme-handler/webcal" = "chromium-browser.desktop";
        "x-scheme-handler/about" = "chromium-browser.desktop";
        "x-scheme-handler/rlogin" = "ktelnetservice6.desktop";
        "x-scheme-handler/ssh" = "ktelnetservice6.desktop";
        "x-scheme-handler/telnet" = "ktelnetservice6.desktop";
      };
    };
  };
}
