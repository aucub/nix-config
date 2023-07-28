{ pkgs, config, lib, ... }: {

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      set -x EDITOR nvim
      mcfly init fish | source
      thefuck --alias | source
      zoxide init fish | source
      # if status is-interactive
          # eval (zellij setup --generate-auto-start fish | string collect)
      # end
    '';
  };
  home.file.".config/fish/fish_variables".source = ./fish_variables;
  home.file.".config/fish/functions".source = ./functions;
}
