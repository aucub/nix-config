{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings.yazi = {
      manager = {
        sort_sensitive = true;
        sort_reverse = true;
        show_hidden = true;
      };
      opener = {
        edit = [
          {
            run = "'${EDITOR:=helix} \"$@\"'";
            desc = "$EDITOR";
            block = true;
            for = "unix";
          }
        ];
      };
      extract = {
        edit = [
          {
            run = "'bsdtar -xf \"$1\"'";
            desc = "Extract here";
            for = "unix";
          }
        ];
      };
    };
  };
}
