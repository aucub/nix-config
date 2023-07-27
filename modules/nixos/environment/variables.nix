{ config, pkgs, ... }: {
  environment = {
    sessionVariables = {
      EDITOR = "helix";
      BROWSER = "firefox";
      TERMINAL = "alacritty";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = "18";
      QT_SCALE_FACTOR = "1";
      GDK_BACKEND = "wayland,x11";
      MOZ_ENABLE_WAYLAND = "1";
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "0";
      CLUTTER_BACKEND = "wayland";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
      LIBVA_DRIVER_NAME = "nvidia";
      ANKI_WAYLAND = "1";
      LIBSEAT_BACKEND = "logind";
      WLR_BACKEND = "vulkan";
      WLR_DRM_NO_ATOMIC = "1";
      WLR_RENDERER = "vulkan";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_BIN_HOME = "$HOME/.local/bin";
      XDG_DATA_HOME = "$HOME/.local/share";
    };
  };
}
