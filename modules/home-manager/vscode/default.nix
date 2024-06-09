{
  inputs,
  pkgs,
  ...
}: {
  programs = {
    vscode = {
      enable = true;
      extensions =
        (with pkgs.vscode-extensions; [
          ms-ceintl.vscode-language-pack-zh-hans
          formulahendry.code-runner
          mhutchie.git-graph
          oderwat.indent-rainbow
          redhat.vscode-yaml
          yzhang.markdown-all-in-one
          ms-python.python
          ms-python.vscode-pylance
          ms-python.debugpy
          charliermarsh.ruff
          foxundermoon.shell-format
          tamasfe.even-better-toml
          bmalehorn.vscode-fish
          nvarner.typst-lsp
          tomoki1207.pdf
          jnoortheen.nix-ide
          github.codespaces
          # ms-vscode.cpptools
          # YoavBls.pretty-ts-errors
          # redhat.vscode-xml
          # rust-lang.rust-analyzer
        ])
        ++ (with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
          rangav.vscode-thunder-client
        ]);
    };
  };
}
