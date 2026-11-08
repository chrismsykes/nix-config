# Neovim + your LazyVim config, unchanged.
#
# Nix installs neovim and the tools LazyVim expects. lazy.nvim and Mason keep managing plugins and
# LSPs the way they always have. That works on NixOS because core enables nix-ld (see base.nix).
{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true; # EDITOR=nvim
    viAlias = true;
    vimAlias = true;
    withPython3 = true; # replaces the pynvim virtualenv script
    withNodeJs = true;
    # The provider settings above would otherwise be written to ~/.config/nvim/init.lua, which
    # collides with the LazyVim config symlinked below. Pass them on neovim's command line instead.
    sideloadInitLua = true;
    extraPackages = with pkgs; [
      # treesitter compiles parsers; Mason installs some tools via npm/pip/cargo
      gcc
      gnumake
      tree-sitter
      nodejs
      python3
      luarocks
      # LazyVim pickers and integrations
      fd
      ripgrep
      lazygit
      wget
      curl
      unzip
    ];
  };

  # Symlink to the repo checkout, not the Nix store, so lazy.nvim can still update lazy-lock.json.
  # Plugin updates show up as a git diff in nix-config; commit them like any other change.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.my.flakePath}/modules/home/files/nvim";
}
