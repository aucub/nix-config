{ inputs, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    extensions =
      (with pkgs.vscode-extensions; [
        ms-ceintl.vscode-language-pack-zh-hans
        formulahendry.code-runner
        redhat.vscode-yaml
        ms-python.python
        charliermarsh.ruff
        foxundermoon.shell-format
        tamasfe.even-better-toml
        nvarner.typst-lsp
        tomoki1207.pdf
        jnoortheen.nix-ide
        github.codespaces
        # bmalehorn.vscode-fish
        # yzhang.markdown-all-in-one
        # ms-vscode.cpptools
        # redhat.vscode-xml
        # rust-lang.rust-analyzer
      ])
      ++ (with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
        rangav.vscode-thunder-client
        # yoavbls.pretty-ts-errors
      ]);
  };
}
