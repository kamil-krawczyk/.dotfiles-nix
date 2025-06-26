{
  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "catppuccin_frappe";
      editor = {
        auto-format = true;
        bufferline = "multiple";
        color-modes = true;
        completion-replace = true;
        cursorline = true;
        line-number = "relative";
        rulers = [79];
      };
      editor.whitespace.characters = {
        space = "·";
        nbsp = "⍽";
        tab = "→";
        newline = "⏎";
        tabpad = "·";
      };
      editor.indent-guides = {
        render = true;
        character = "┊";
        skip-levels = 0;
      };
      editor.soft-wrap = {
        enable = true;
      };
      editor.file-picker = {
        hidden = false;
        git-ignore = false;
      };
      editor.statusline = {
        left = [
          "mode"
          "spacer"
          "version-control"
          "spacer"
          "separator"
          "file-name"
          "file-modification-indicator"
        ];
        right = [
          "spinner"
          "spacer"
          "workspace-diagnostics"
          "separator"
          "spacer"
          "diagnostics"
          "position"
          "file-encoding"
          "file-line-ending"
          "file-type"
        ];
        separator = "╎";
        mode.normal = "NORMAL";
        mode.insert = "INSERT";
        mode.select = "SELECT";
      };
      keys.normal = {
        esc = ["collapse_selection" "keep_primary_selection" ":w"];
      };
      keys.normal.g = {
        q = ":bc";
        Q = ":bc!";
      };
    };
  };
}
