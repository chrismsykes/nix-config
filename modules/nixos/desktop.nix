{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop;
in
{
  options.my.desktop = {
    enable = lib.mkEnableOption "a KDE Plasma 6 desktop (Wayland) with PipeWire audio";

    remote.enable = lib.mkEnableOption ''
      remote access to the Plasma session over RDP (KRDP, part of Plasma). Logs the user in
      automatically at boot so there is a session to connect to. Turn the server on once under
      System Settings > Remote Desktop, which is also where its RDP username and password are set
    '';
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.defaultSession = "plasma"; # Wayland
    services.displayManager.autoLogin = lib.mkIf cfg.remote.enable {
      enable = true;
      user = config.my.user.name;
    };
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.remote.enable [ 3389 ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    services.desktopManager.plasma6.enable = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    hardware.bluetooth.enable = true;

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      nerd-fonts.meslo-lg # the font powerlevel10k expects; set your terminal to "MesloLGS Nerd Font"
    ];

    environment.systemPackages = with pkgs; [
      firefox
    ];
  };
}
