{ pkgs, lib, config, ... }:

{

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    dotDir = ".config/zsh";
    history = {
      path = "${config.xdg.cacheHome}/zsh_history";
      save = 1000;
    };
    initExtra = ''
      source ${./zshrc}
    '';
  };

}
