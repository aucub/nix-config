{ pkgs, lib, config, ... }:

{

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    history = {
      path = "${config.xdg.cacheHome}/zsh_history";
      save = 1000;
    };
  };

  home.file.".zshrc" = {
    source = ./zshrc;
    recursive = true;
  };

}
