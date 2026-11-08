{ config, lib, ... }:
let
  cfg = config.my.onepassword;
in
{
  options.my.onepassword = {
    enable = lib.mkEnableOption "the 1Password CLI (`op`)";
    gui = lib.mkEnableOption "the 1Password desktop app";
  };

  # Set at the system level (not in home-manager) because the CLI needs a setgid wrapper
  # to talk to the desktop app.
  config = lib.mkIf cfg.enable {
    programs._1password.enable = true;
    programs._1password-gui = lib.mkIf cfg.gui {
      enable = true;
      polkitPolicyOwners = [ config.my.user.name ];
    };
  };
}
