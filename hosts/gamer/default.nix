# Gaming PC with a GTX 1080 Ti.
{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Leave the kernel at the NixOS default (LTS). The legacy NVIDIA driver can lag behind
  # the newest kernels, and pinning linuxPackages_latest is the usual way that breaks.

  my = {
    desktop.enable = true;
    nvidia.enable = true; # defaults to the legacy_580 branch for Pascal
    gaming.enable = true;
  };

  system.stateVersion = "26.05";
}
