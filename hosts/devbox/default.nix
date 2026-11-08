# Main dev VM: git repos, kubernetes, all the secrets.
{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Create the VM with UEFI firmware (OVMF in Proxmox/libvirt) so systemd-boot works.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  my = {
    vmGuest.enable = true;
    desktop.enable = true; # for the occasional GUI-only thing; day to day is Rex/SSH
    desktop.remote.enable = true;
    containers.enable = true;
    onepassword.enable = true;
    # Turn this on after the first install, once secrets/devbox.yaml exists (see README).
    secrets.enable = false;

    user.linger = true;
    user.home = {
      my.dev.enable = true;
      my.rex.server.enable = true;
    };
  };

  # The NixOS release this machine was FIRST installed with. Never bump it later,
  # even when you upgrade nixpkgs. It isn't a version pin, see README.
  system.stateVersion = "26.05";
}
