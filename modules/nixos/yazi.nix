{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.yazi = {
    enable = true;
    settings.yazi = {
      manager = {
        layout = [1 4 3];
        sort_by = "alphabetical";
        sort_sensitive = true;
        sort_reverse = true;
        sort_dir_first = true;
        show_hidden = true;
      };

      opener = {
        edit = [
          { run = '${EDITOR:=helix} "$@"'; desc = "$EDITOR";block = true; for = "unix" }
        ];

        extract = [
          { run = 'bsdtar -xf "$1"'; desc = "Extract here"; for = "unix"; }
        ];

      };
      };
    };
  };
}
