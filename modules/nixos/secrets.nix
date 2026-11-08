# Secrets via sops-nix. Encrypted files live in secrets/<hostname>.yaml and are safe to commit.
# Each machine decrypts its own file at boot with a key derived from its SSH host key, and the
# plaintext only exists under /run/secrets (tmpfs). Never in the Nix store.
#
# Setup steps are in README.md under "Secrets".
{ config, lib, ... }:
let
  cfg = config.my.secrets;
in
{
  options.my.secrets.enable = lib.mkEnableOption "sops-nix secrets from secrets/<hostname>.yaml";

  config = lib.mkIf cfg.enable {
    sops = {
      defaultSopsFile = ../../secrets + "/${config.networking.hostName}.yaml";
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };
  };
}
