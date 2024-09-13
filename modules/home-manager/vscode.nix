{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions =
      (with pkgs.vscode-extensions; [
        ms-ceintl.vscode-language-pack-zh-hans
        formulahendry.code-runner
        redhat.vscode-yaml
        ms-python.python
        charliermarsh.ruff
        foxundermoon.shell-format
        tamasfe.even-better-toml
        myriad-dreamin.tinymist
        tomoki1207.pdf
        jnoortheen.nix-ide
        # github.codespaces
        # bmalehorn.vscode-fish
        # yzhang.markdown-all-in-one
        # ms-vscode.cpptools
        # redhat.vscode-xml
        # rust-lang.rust-analyzer
      ])
      ++ (with pkgs.vscode-marketplace; [
        rangav.vscode-thunder-client
        # yoavbls.pretty-ts-errors
      ]);
  };
}
