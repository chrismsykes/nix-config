# Everyday CLI tools on every machine. This replaces most of the mise [tools] list and the apt
# installs from the chezmoi dotfiles. Nix pins the versions in flake.lock, so `nix flake update`
# is the new "upgrade everything".
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    age
    bat
    eza
    fastfetch
    fd
    fzf
    gdu
    jq
    just
    ripgrep
    shellcheck
    tree
    units
    unzip
    uv
    watchexec
    yq-go
    zoxide
  ];

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "TTY";
      theme_background = false;
    };
  };

  programs.lazygit = {
    enable = true;
    settings.git.pagers = [
      # delta can't detect the terminal background inside lazygit, so set it.
      { pager = "delta --dark --paging=never"; }
    ];
  };

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--glob=!vendor"
      "--hidden"
      "--line-number"
      "--no-heading"
      "--sort=path"
    ];
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*".HashKnownHosts = "no";
      "github.com".User = "chrismsykes";
    };
  };
}
