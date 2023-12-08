{lib, ...}:
with lib.hm.gvariant; {
  dconf.settings = {
    "app/drey/Damask" = {
      active-source = "wallhaven";
      refresh-interval = "86400";
      run-in-background = false;
    };

    "app/drey/Damask/sources/wallhaven" = {
      category-anime = true;
      category-general = false;
      category-people = false;
      purity-sfw = true;
      sort-by = "toplist";
      top-list-range = "1w";
    };

    "io/github/celluloid-player/celluloid" = {
      dark-theme-enable = true;
    };

    "org/gnome/Console" = {
      audible-bell = true;
      font-scale = 1.4000000000000004;
      last-window-size = mkTuple [1578 905];
      restore-window-size = true;
      shell = ["fish"];
      theme = "night";
      use-system-font = true;
      visual-bell = true;
    };

    "org/gnome/Snapshot" = {
      is-maximized = false;
      play-shutter-sound = false;
      window-height = 640;
      window-width = 800;
    };

    "org/gnome/TextEditor" = {
      discover-settings = true;
      highlight-current-line = false;
      restore-session = false;
      show-grid = false;
      show-line-numbers = true;
      show-map = true;
      show-right-margin = false;
      spellcheck = false;
      style-scheme = "Adwaita";
      use-system-font = true;
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = ["Utilities"];
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = ["org.gnome.tweaks.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.Logs.desktop" "auto-cpufreq-gtk.desktop" "org.gnome.font-viewer.desktop" "htop.desktop" "org.gnome.Extensions.desktop" "ca.desrt.dconf-editor.desktop" "app.drey.Damask.desktop" "org.gnome.Loupe.desktop" "mpv.desktop" "org.gnome.Evince.desktop" "fcitx5-configtool.desktop" "kbd-layout-viewer5.desktop" "bssh.desktop" "bvnc.desktop" "avahi-discover.desktop" "fish.desktop" "lstopo.desktop" "helix.desktop" "qv4l2.desktop" "qvidcap.desktop" "org.fcitx.Fcitx5.desktop" "org.fcitx.fcitx5-migrator.desktop" "electron25.desktop" "jshell-java17-openjdk.desktop" "jconsole-java17-openjdk.desktop"];
      categories = ["X-GNOME-Utilities"];
      excluded-apps = ["org.gnome.Console.desktop"];
      name = "Utilities";
      translate = false;
    };

    "org/gnome/desktop/input-sources" = {
      mru-sources = [(mkTuple ["xkb" "us"])];
      sources = [(mkTuple ["xkb" "us"])];
      xkb-options = ["terminate:ctrl_alt_bksp" "lv3:ralt_switch"];
    };

    "org/gnome/desktop/interface" = {
      clock-show-date = true;
      clock-show-seconds = false;
      clock-show-weekday = true;
      color-scheme = "default";
      cursor-size = 24;
      enable-animations = true;
      font-antialiasing = "rgba";
      font-hinting = "slight";
      document-font-name = "更纱黑体 UI SC 11";
      font-name = "更纱黑体 UI SC 11";
      monospace-font-name = "等距更纱黑体 SC 11";
      gtk-enable-primary-paste = false;
      gtk-theme = "Orchis-Purple-Compact-Nord";
      icon-theme = "Adwaita";
      show-battery-percentage = true;
      text-scaling-factor = 1.25;
      toolkit-accessibility = false;
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "adaptive";
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      accel-profile = "adaptive";
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/privacy" = {
      hide-identity = true;
      old-files-age = mkUint32 7;
      recent-files-max-age = -1;
      remember-recent-files = false;
      remove-old-temp-files = true;
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 300;
    };

    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
      event-sounds = true;
      theme-name = "freedesktop";
    };

    "org/gnome/file-roller/listing" = {
      list-mode = "as-folder";
      name-column-width = 250;
      show-path = false;
      sort-method = "name";
      sort-type = "ascending";
    };

    "org/gnome/gnome-system-monitor" = {
      current-tab = "processes";
      kill-dialog = false;
      maximized = true;
      network-total-in-bits = false;
      process-memory-in-iec = true;
      resources-memory-in-iec = true;
      show-dependencies = false;
      show-whose-processes = "user";
      window-state = mkTuple [1920 1040 0 0];
    };

    "org/gnome/gnome-system-monitor/disktreenew" = {
      col-0-visible = true;
      col-0-width = 251;
      col-1-visible = true;
      col-1-width = 241;
      col-3-visible = true;
      col-3-width = 148;
      col-5-visible = true;
      col-5-width = 133;
      col-6-visible = true;
      col-6-width = 0;
      columns-order = [0 1 2 3 4 5 6];
      sort-col = 0;
      sort-order = 1;
    };

    "org/gnome/gnome-system-monitor/openfilestree" = {
      sort-col = 0;
      sort-order = 0;
    };

    "org/gnome/gnome-system-monitor/proctree" = {
      col-12-visible = true;
      col-12-width = 290;
      col-8-visible = true;
      col-8-width = 117;
      columns-order = [0 1 2 3 4 6 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26];
      sort-col = 12;
      sort-order = 0;
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = false;
      center-new-windows = true;
      workspaces-only-on-primary = true;
      edge-tiling = true;
    };

    "org/gnome/nautilus/compression" = {
      default-compression-format = "zip";
    };

    "org/gnome/nautilus/list-view" = {
      default-column-order = ["name" "size" "type" "owner" "group" "permissions" "where" "date_modified" "date_modified_with_time" "date_accessed" "date_created" "recency" "detailed_type"];
      default-visible-columns = ["name" "size" "date_modified"];
      use-tree-view = false;
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      install-mime-activation = false;
      migrated-gtk-settings = true;
      recursive-search = "never";
      search-filter-time-type = "last_modified";
    };

    "org/gnome/desktop/wm/preferences" = {
      action-right-click-titlebar = "toggle-maximize";
      resize-with-right-button = true;
      mouse-button-modifier = "<super>";
      titlebar-font = "更纱黑体 UI SC 11";
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/gnome/online-accounts" = {
      whitelisted-providers = [];
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = false;
      night-light-schedule-from = 0.0;
      night-light-schedule-to = 0.0;
      night-light-temperature = mkUint32 3854;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [];
    };
    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = ["<super>left"];
      toggle-tiled-right = ["<super>right"];
    };

    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = true;
      sleep-inactive-ac-timeout = 1200;
      sleep-inactive-ac-type = "suspend";
      sleep-inactive-battery-type = "suspend";
    };

    "org/gnome/shell" = {
      command-history = ["/*+"];
      disable-user-extensions = false;
      disabled-extensions = ["window-list@gnome-shell-extensions.gcampax.github.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com" "light-style@gnome-shell-extensions.gcampax.github.com" "apps-menu@gnome-shell-extensions.gcampax.github.com"];
      enabled-extensions = ["appindicatorsupport@rgcjonas.gmail.com" "caffeine@patapon.info" "kimpanel@kde.org"];
      favorite-apps = ["org.gnome.Nautilus.desktop" "hiddify.desktop" "firefox.desktop" "org.gnome.Console.desktop"];
      welcome-dialog-last-shown-version = "45.0";
    };

    "org/gnome/shell/extensions/appindicator" = {
      tray-pos = "left";
    };

    "org/gnome/shell/extensions/caffeine" = {
      countdown-timer = 0;
      enable-fullscreen = false;
      indicator-position-max = 3;
      toggle-state = false;
      user-enabled = false;
    };

    "org/gnome/shell/keybindings" = {
      toggle-message-tray = [];
    };

    "org/gnome/desktop/wm/keybindings" = {
      maximize = ["<super>up"];
      unmaximize = ["<super>down"];
      switch-to-workspace-left = ["<alt>left"];
      switch-to-workspace-right = ["<alt>right"];
      move-to-workspace-left = ["<shift><alt>left"];
      move-to-workspace-right = ["<shift><alt>right"];
      move-to-monitor-left = ["<super><alt>left"];
      move-to-monitor-right = ["<super><alt>right"];
      close = ["<super>q" "<alt>f4"];
      toggle-fullscreen = ["<super>f"];
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "system/locale" = {
      region = "zh_CN.UTF-8";
    };

    "org/gnome/shell/extensions/kimpanel" = {
      font = "更纱黑体 UI SC 14";
    };
  };
}
