{
  flake,
  pkgs,
  config,
  ...
}:
let
  user = flake.config.users."${config.home.username}";
  cursorName = user.cursorName;
  cursorPackage = user.cursorPackage pkgs;
  cursorSize = user.cursorSize;
in
{
  home = {
    pointerCursor = {
      name = cursorName;
      package = cursorPackage;
      size = cursorSize;
      gtk.enable = true;
      x11 = {
        enable = true;
        defaultCursor = cursorName;
      };
    };
    language.base = "zh_CN.UTF-8";
  };

  gtk.cursorTheme = {
    name = cursorName;
    size = cursorSize;
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
