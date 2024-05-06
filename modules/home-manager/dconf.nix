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

    "org/gnome/Snapshot" = {
      is-maximized = false;
      play-shutter-sound = false;
      window-height = 640;
      window-width = 800;
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

    "org/gnome/file-roller/listing" = {
      list-mode = "as-folder";
      name-column-width = 250;
      show-path = false;
      sort-method = "name";
      sort-type = "ascending";
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

    "system/locale" = {
      region = "zh_CN.UTF-8";
    };
  };
}
