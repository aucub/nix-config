{ ... }:
{
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
    binding = "<Alt>space";
    command = "wofi --normal-window --show drun";
    name = "wofi";
  };

  programs.wofi = {
    enable = true;
    settings = {
      style = "\${HOME}/.config/wofi/style.css";
      xoffset = 660;
      yoffset = 275;
      show = "drun";
      width = 600;
      height = 500;
      always_parse_args = true;
      show_all = true;
      print_command = true;
      layer = "overlay";
      insensitive = true;
      prompt = "";
    };
    style = ''
      window {
        margin = 0px;
        border = 2px solid #4c566a;
        border-radius = 5px;
        background-color = #3b4252;
        font-family = monospace;
        font-size = 12px;
      }

      #input {
        margin = 5px;
        border = 1px solid #3b4252;
        color = #eceff4;
        background-color = #3b4252;
      }

      #input image {
        color = #eceff4;
      }

      #inner-box {
        margin = 5px;
        border = none;
        background-color = #3b4252;
      }

      #outer-box {
        margin = 5px;
        border = none;
        background-color = #3b4252;
      }

      #scroll {
        margin = 0px;
        border = none;
      }

      #text {
        margin = 5px;
        border = none;
        color = #eceff4;
      }

      #entry:selected {
        background-color = #4c566a;
        font-weight = normal;
      }

      #text:selected {
        background-color = #4c566a;
        font-weight = normal;
      }
    '';
  };
}
