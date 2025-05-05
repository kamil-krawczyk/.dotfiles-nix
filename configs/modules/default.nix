{config, ...}: {
  home = {
    username = "kamil";
    homeDirectory =
      if config.host.isLinux
      then "/home/kamil"
      else "/Users/kamil";
  };

  programs.home-manager.enable = true;

  imports = [
    ./zsh.nix
    ./oh-my-posh.nix
    ./fzf.nix
    ./eza.nix

    ./helix.nix

    ./git.nix
    ./direnv.nix
  ];
}
