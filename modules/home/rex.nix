# Rex: the `rex` CLI and terminfo everywhere, plus an optional personal server on machines
# you connect into. Uses Rex's own home-manager module, so this works on non-NixOS too.
{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.my.rex.server;
in
{
  imports = [ inputs.rex.homeManagerModules.default ];

  options.my.rex.server = {
    enable = lib.mkEnableOption ''
      a Rex personal server for this user (systemd user service). On NixOS, pair it with
      `my.user.linger = true` so it keeps running without a login and sessions survive a logout
    '';

    tailscaleHostname = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "devbox";
      description = ''
        Put the server on your tailnet as https://<name>.<tailnet>.ts.net, using Rex's built-in
        Tailscale (no Tailscale install needed). Null keeps it local-only. The first start needs
        a one-time sign-in: the link is shown by `rex server status` on the machine. The name
        must be unique per machine; changing it enrolls a new node.
      '';
    };
  };

  config = {
    programs.rex.enable = true; # also adds the SSH fallback to ~/.ssh/config (see cli.nix)
    services.rex = {
      enable = cfg.enable;
      tailscale = lib.mkIf (cfg.tailscaleHostname != null) {
        enable = true;
        hostname = cfg.tailscaleHostname;
      };
    };
  };
}
