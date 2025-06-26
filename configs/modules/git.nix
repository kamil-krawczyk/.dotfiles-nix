{
  config,
  lib,
  inputs,
  ...
}: let
  sshPubKeyPath = "${inputs.self}/configs/modules/${config.host.profile}/id_ed25519.pub";
in {
  home.file = {
    ".ssh/allowed_signers".text = "${config.user.email} namespaces=\"git\" ${builtins.readFile "${sshPubKeyPath}"}";
    ".config/git/config.private".text = "[user]\n\tname = \"Kamil Krawczyk\"\n\temail = \"kamil.krawczyk87@gmail.com\"\n";
  };

  programs.git = {
    enable = true;
    userName = "Kamil Krawczyk";
    userEmail = config.user.email;
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
    includes = [
      {
        path = "~/.config/git/config.private";
        condition = "gitdir:~/.dotfiles-nix/";
      }
    ];
    extraConfig =
      {
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
        init.defaultBranch = "main";
        merge.conflictstyle = "zdiff3";
      }
      // lib.attrsets.optionalAttrs (config.host.profile == "macro-system") {
        url = {
          "ssh://git-server.macro2.local/" = {
            insteadOf = "https://git-server.macro2.local/";
          };
        };
      };
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        side-by-side = true;
      };
    };
  };
}
