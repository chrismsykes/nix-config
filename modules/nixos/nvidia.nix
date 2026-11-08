{ config, lib, ... }:
let
  cfg = config.my.nvidia;
in
{
  options.my.nvidia = {
    enable = lib.mkEnableOption "the proprietary NVIDIA driver";

    branch = lib.mkOption {
      type = lib.types.str;
      # The 1080 Ti is Pascal. NVIDIA dropped Pascal after the 580 series, so it needs the
      # long-lived 580 branch. A newer card (Turing/20-series or later) would use "stable" here.
      default = "legacy_580";
      description = "Value for hardware.nvidia.branch.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.nvidia = {
      branch = cfg.branch;
      # Pascal has no GSP, so the open kernel module can't drive it.
      open = false;
      modesetting.enable = true; # required for Wayland
      nvidiaSettings = true;
    };
  };
}
