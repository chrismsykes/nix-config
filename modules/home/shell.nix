# zsh + oh-my-zsh + powerlevel10k, ported from the chezmoi dotfiles (dot_zshrc.tmpl).
{ lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    # These were omz "custom" plugins downloaded by chezmoi; home-manager has them built in.
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    autocd = true;
    history = {
      size = 50000;
      save = 50000;
      ignoreSpace = true; # was: setopt histignorespace
      share = true;
    };

    oh-my-zsh = {
      enable = true;
      # Same list as .chezmoi.toml.tmpl, minus: "ubuntu" (apt aliases), "themes", and the three
      # non-omz plugins (autosuggestions/syntax-highlighting above, you-should-use below).
      plugins = [
        "aliases"
        "ansible"
        "colored-man-pages"
        "docker-compose"
        "extract"
        "eza"
        "fancy-ctrl-z"
        "fzf"
        "gh"
        "git"
        "helm"
        "kubectl"
        "nmap"
        "npm"
        "per-directory-history"
        "rsync"
        "ssh"
        "sudo"
        "systemd"
        "terraform"
        "tmux"
        "vi-mode"
        "virtualenv"
        "zoxide"
        "zsh-interactive-cd"
      ];
      extraConfig = ''
        HYPHEN_INSENSITIVE="true"
        CASE_SENSITIVE="true"
        HIST_STAMPS="yyyy-mm-dd"
      '';
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
    ];

    initContent = lib.mkMerge [
      # p10k instant prompt has to be the very first thing in .zshrc.
      (lib.mkBefore ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      ''
        setopt rm_star_silent
        setopt interactivecomments
        setopt long_list_jobs

        # To change the prompt, run `p10k configure`, then copy ~/.p10k.zsh over
        # modules/home/files/p10k.zsh in the nix-config repo.
        source ${./files/p10k.zsh}
      ''
    ];

    shellAliases = {
      cat = "bat";
    };
  };

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
  ];

  home.sessionVariables = {
    GOPATH = "$HOME";
    GO111MODULE = "on";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  # Ctrl+R history search. Atuin's zsh hook loads after omz's fzf plugin, so it takes Ctrl+R (same as before).
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  # Per-repo environments: put `use flake` (or `use mise`) in a repo's .envrc.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.readline = {
    enable = true;
    extraConfig = ''
      set editing-mode vi
      set keymap vi
      set keymap vi-insert
    '';
  };

  programs.tmux = {
    enable = true;
    prefix = "C-a";
    extraConfig = ''
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
    '';
  };
}
