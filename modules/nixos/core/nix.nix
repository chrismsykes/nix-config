{ config, inputs, ... }:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
    # This repo is the only source of truth; no imperative channels.
    channel.enable = false;
  };

  nixpkgs.config.allowUnfree = true;

  # `pkgs.unstable.foo` gets foo from nixos-unstable, with the same nixpkgs config.
  nixpkgs.overlays = [
    (final: _prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (final.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    })
  ];

  # `nh os switch` / `nh os test` / `nh os boot`: nicer nixos-rebuild with diffs.
  # Also handles garbage collection (so nix.gc stays off).
  programs.nh = {
    enable = true;
    flake = "/home/${config.my.user.name}/nix-config";
    clean = {
      enable = true;
      extraArgs = "--keep 10 --keep-since 14d";
    };
  };
}
