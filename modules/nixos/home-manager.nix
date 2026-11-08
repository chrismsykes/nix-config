# Wires home-manager into NixOS: one `nh os switch` updates the system and the user's dotfiles together.
# modules/home stays free of NixOS-only assumptions, so it could later be used standalone
# (on macOS or another distro) without a rewrite.
{
  config,
  inputs,
  lib,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit inputs; };

    users.${config.my.user.name} = {
      imports = [
        ../home
        config.my.user.home
      ];
      home.stateVersion = lib.mkDefault config.system.stateVersion;
    };
  };
}
