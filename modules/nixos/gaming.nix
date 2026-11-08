{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.gaming;
in
{
  options.my.gaming.enable = lib.mkEnableOption "Steam, Proton-GE, gamemode and gamescope";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    programs.gamemode.enable = true;
    programs.gamescope.enable = true;

    environment.systemPackages = with pkgs; [
      mangohud
    ];
  };
}
