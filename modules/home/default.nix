# home-manager modules: your user environment (shell, CLI tools, dotfiles).
# These must not depend on NixOS (no `osConfig`), so they can be reused on macOS or another distro later.
# Optional pieces sit behind `my.<name>.enable`, like the NixOS modules.
{ config, lib, ... }:
{
  imports = [
    ./cli.nix
    ./dev.nix
    ./git.nix
    ./neovim.nix
    ./rex.nix
    ./shell.nix
  ];

  options.my.flakePath = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/nix-config";
    description = ''
      Where this repo is checked out. Used to symlink configs that apps need to write to
      (like LazyVim's lazy-lock.json) straight to the repo instead of the read-only Nix store.
    '';
  };

  config.programs.home-manager.enable = true;
}
