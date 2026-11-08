# Generic dev VM: no secrets, no kubernetes toolbox. A clean place to try things out,
# including a full desktop to test-drive NixOS before installing it on real hardware.
{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  my = {
    vmGuest.enable = true;
    desktop.enable = true;
    desktop.remote.enable = true;
    containers.enable = true;

    user.linger = true;
    user.home = {
      my.rex.server.enable = true;
    };
  };

  system.stateVersion = "26.05";
}
