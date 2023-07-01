{ pkgs, config, lib, ... }: {

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      set -x EDITOR helix
      mcfly init fish | source
    '';
  };
  home.file.".config/fish/fish_variables".source = ./fish_variables;
  home.file.".config/fish/functions".source = ./functions;
}