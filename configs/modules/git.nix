{config, ...}: {
  programs.git = {
    enable = true;
    userName = "Kamil Krawczyk";
    userEmail = config.user.email;
    # signing = {
    #   format = "ssh";
    #   key = "~/.ssh/id_ed25519.pub";
    #   signByDefault = true;
    # };
    # includes = [
    #   {
    #     path = "~/.config/git/config.private";
    #     condition = "gitdir:~/.dotfiles-nix/";
    #   }
    #   {
    #     path = "~/.config/git/config.private";
    #     condition = "gitdir:~/.secrets-nix/";
    #   }
    # ];
    extraConfig = {
      # gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      init.defaultBranch = "main";
    };
    delta = {
      enable = true;
      options = {
        side-by-side = true;
      };
    };
  };
}
