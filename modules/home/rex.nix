# Rex: the `rex` CLI and terminfo everywhere, plus an optional personal server on machines
# you connect into. Uses Rex's own home-manager module, so this works on non-NixOS too.
{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.rex.homeManagerModules.default ];

  options.my.rex.server.enable = lib.mkEnableOption ''
    a Rex personal server for this user (systemd user service). On NixOS, pair it with
    `my.user.linger = true` so it keeps running without a login and sessions survive a logout
  '';

  config = {
    programs.rex.enable = true; # also adds the SSH fallback to ~/.ssh/config (see cli.nix)
    services.rex.enable = config.my.rex.server.enable;
  };
}
