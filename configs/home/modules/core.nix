{
  config,
  lib,
  pkgs,
  inputs,
  hostConfig,
  ...
}:
with lib; let
  user = hostConfig.user."${config.home.username}";
  sshPubKeyPath = "${inputs.self}/configs/home/${config.home.username}_${user.profile}/id_ed25519.pub";
  sshConfigPath = "${builtins.toString inputs.secrets}/${user.profile}/ssh-client-config";
in {
  config = mkMerge [
    ### linux #################################################################
    (mkIf (hostConfig.isLinux) {
      fonts.fontconfig.enable = true;

      home.packages = with pkgs; [
        evince
        firefox
        gimp
        libreoffice

        nerd-fonts.jetbrains-mono
      ];

      dconf.settings = {
        "org/gnome/desktop/media-handling" = {
          automount = false;
          automount-open = false;
        };
        "org/gnome/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,maximize,close";
          num-workspaces = 6;
        };
        "org/gnome/mutter" = {
          edge-tiling = true;
        };
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = [
            "caffeine@patapon.info"
            "todoit@wassimbj.github.io"
            "weatheroclock@CleoMenezesJr.github.io"
          ];
        };
        "org/gnome/settings-daemon/plugins/power" = {
          power-button-action = "nothing";
          sleep-inactive-ac-type = "nothing";
          sleep-inactive-battery-type = "nothing";
        };
      };
    })
    ### shared ################################################################
    (mkIf (builtins.pathExists sshConfigPath) {
      home.file.".ssh/config".text = "${builtins.readFile sshConfigPath}";
    })
    {
      home.file.".ssh/allowed_signers".text = "${user.email} namespaces=\"git\" ${builtins.readFile "${sshPubKeyPath}"}";

      programs = {
        home-manager.enable = true;

        git = {
          enable = true;
          userName = user.fullName;
          userEmail = user.email;
          signing = {
            format = "ssh";
            key = "~/.ssh/id_ed25519.pub";
            signByDefault = true;
          };
          extraConfig = {
            gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
          };
          delta = {
            enable = true;
            options = {
              side-by-side = true;
            };
          };
        };

        zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          history.ignoreAllDups = true;
          shellAliases = {
            l = "eza";
            ls = "eza";
            l1 = "eza -1";
            ll = "eza -l";
            la = "eza -la";
            ld = "eza -lD";
            lf = "eza -lf";
            lt = "eza -T";
            tree = "eza -T";
          };
        };

        oh-my-posh = {
          enable = true;
          enableZshIntegration = true;
          useTheme = "slimfat";
        };

        fzf = {
          enable = true;
          enableZshIntegration = true;
        };

        eza = {
          enable = true;
          enableZshIntegration = true;
          git = true;
          colors = "auto";
          icons = "auto";
          extraOptions = [
            "--group"
            "--group-directories-first"
            "--mounts"
          ];
        };

        helix = {
          enable = true;
          defaultEditor = true;
          settings = {
            theme = "monokai_pro_spectrum";
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

        tmux = {
          enable = true;
          clock24 = true;
          mouse = true;
          terminal = "screen-256color";
        };
      };
    }
  ];
}
