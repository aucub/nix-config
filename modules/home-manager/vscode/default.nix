{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  vars,
  ...
}: {
  programs = {
    vscode = {
      enable = true;
      enableExtensionUpdateCheck = false;
      enableUpdateCheck = false;
      extensions =
        (with pkgs.vscode-extensions; [
          # ms-vscode.cpptools
          ms-ceintl.vscode-language-pack-zh-hans
          formulahendry.code-runner
          mhutchie.git-graph
          oderwat.indent-rainbow
          # rust-lang.rust-analyzer
          redhat.vscode-yaml
          redhat.vscode-xml
          yzhang.markdown-all-in-one
          ms-python.python
          ms-python.vscode-pylance
          # ms-python.black-formatter
          foxundermoon.shell-format
          tamasfe.even-better-toml
          bmalehorn.vscode-fish
        ])
        ++ (with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
          bito.bito
          rangav.vscode-thunder-client
        ]);
        userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
    };
  };
}
