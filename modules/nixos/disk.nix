# Disk layout as code (disko). nixos-anywhere reads this to partition and format a machine
# during install, and NixOS uses it to know what to mount.
#
# Hosts that use this must NOT define fileSystems in hardware-configuration.nix; nixos-anywhere
# generates that file with --no-filesystems for exactly that reason.
{ config, lib, ... }:
let
  cfg = config.my.disk;
in
{
  options.my.disk = {
    enable = lib.mkEnableOption "the standard disk layout: GPT, 1 GB EFI boot partition, ext4 root";

    device = lib.mkOption {
      type = lib.types.str;
      default = "/dev/sda"; # Proxmox VirtIO SCSI disk
      description = "Disk to install onto. Everything on it is erased at install time.";
    };
  };

  config = lib.mkIf cfg.enable {
    disko.devices.disk.main = {
      type = "disk";
      device = cfg.device;
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
