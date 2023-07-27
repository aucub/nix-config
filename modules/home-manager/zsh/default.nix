{ pkgs, lib, config, ... }:

{

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    autosuggestions = {
      enable = true;
      strategy = [ "match_prev_cmd" ]; # one of "history", "match_prev_cmd"
    };
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
