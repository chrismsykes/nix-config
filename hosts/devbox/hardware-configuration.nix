# PLACEHOLDER. nixos-anywhere overwrites this at install time with the real hardware scan
# (--generate-hardware-config). Filesystems come from disko (my.disk), not from this file.
{ lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
