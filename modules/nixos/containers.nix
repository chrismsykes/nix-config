{ config, lib, ... }:
let
  cfg = config.my.containers;
in
{
  options.my.containers.enable = lib.mkEnableOption "Docker, for local containers and kind/k3d clusters";

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      autoPrune.enable = true;
    };
    users.users.${config.my.user.name}.extraGroups = [ "docker" ];
  };
}
