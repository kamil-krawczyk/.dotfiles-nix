{
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    colors = "auto";
    icons = "auto";
    theme = "catppuccin";
    extraOptions = [
      "--group"
      "--group-directories-first"
      "--mounts"
    ];
  };

  programs.zsh.shellAliases = {
    l = "eza";
    ls = "eza";
    l1 = "eza -1";
    ll = "eza -l";
    la = "eza -la";
    lt = "eza -T";
    tree = "eza -T";
  };
}
