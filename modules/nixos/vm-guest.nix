{ config, lib, ... }:
let
  cfg = config.my.vmGuest;
in
{
  options.my.vmGuest.enable = lib.mkEnableOption "QEMU/KVM guest support (Proxmox, libvirt, UTM)";

  # nixos-generate-config already adds the virtio kernel modules to hardware-configuration.nix.
  # This adds the guest agent, so the hypervisor can see the IP and shut the VM down cleanly.
  config = lib.mkIf cfg.enable {
    services.qemuGuest.enable = true;

    # With a desktop on the VM: shared clipboard and auto-resize in a SPICE console.
    services.spice-vdagentd.enable = config.my.desktop.enable;
  };
}
