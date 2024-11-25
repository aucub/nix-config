{ pkgs, ... }:
{
  systemPackages = with pkgs; [
    nixd
    python3Packages.python-lsp-server
  ];
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "toml"
      "sql"
      "log"
      "pylsp"
      "basher"
      "fish"
      "just"
      "typst"
      "ruff"
    ]; # "ini" "make"
    userSettings = {
      features = {
        copilot = false;
        inline_completion_provider = "none";
      };
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      autosave = "off";
      auto_update = false;
      buffer_font_family = "Sarasa Mono SC";
      buffer_font_size = 22;
      inline_completions.disabled_globs = [
        ".env"
        ".age"
        ".enc"
      ];
      cursor_blink = false;
      ui_font_family = "Sarasa UI SC";
      ui_font_size = 24;
      tabs = {
        file_icons = true;
        git_status = true;
      };
      format_on_save = "off";
      file_scan_exclusions = [
        "**/.git"
        "**/.svn"
        "**/.hg"
        "**/CVS"
        "**/.DS_Store"
        "**/Thumbs.db"
        "**/.classpath"
        "**/.settings"
        "**/__pycache__"
        "**/.venv"
      ];
      git.inline_blame.enabled = false;
      journal = {
        path = "~";
        hour_format = "hour24";
      };
      assistant = {
        enabled = false;
        version = "2";
      };
      theme = {
        mode = "system";
        dark = "Andromeda";
        light = "One Light";
      };
    };
  };
}
