{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.user;
in
{
  options.my.user = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "chris";
      description = "Login name of the main user. Use this option instead of hardcoding the name.";
    };

    sshKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        # TODO: check this is the key you want. It came from ~/.ssh/authorized_keys on the Ubuntu box.
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB8Nc9eN7rUz/y6nKJByyw++iTnjAMCsIOv72k8sI+qN"
      ];
      description = "Public keys allowed to SSH in as the main user.";
    };

    linger = lib.mkEnableOption ''
      lingering, so the user's systemd services (like the Rex server) start at boot and keep
      running after logout
    '';

    home = lib.mkOption {
      type = lib.types.deferredModule;
      default = { };
      description = ''
        Extra home-manager config for the main user on this host, for example
        `my.user.home = { my.dev.enable = true; };`
      '';
    };
  };

  config = {
    users.users.${cfg.name} = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = cfg.sshKeys;
      linger = cfg.linger;
    };
  };
}
