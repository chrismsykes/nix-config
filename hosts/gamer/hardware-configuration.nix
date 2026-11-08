# PLACEHOLDER. Replace this file with the real one from the machine:
#   nixos-generate-config --root /mnt --show-hardware-config > hosts/<host>/hardware-configuration.nix
# The labels below match the NixOS manual's partitioning steps, so the flake evaluates before install.
{ lib, ... }:
{
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
