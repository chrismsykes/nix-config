{ lib, pkgs, ... }:
{
  # TODO: set your timezone.
  time.timeZone = lib.mkDefault "America/Chicago";
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  networking.networkmanager.enable = lib.mkDefault true;
  networking.firewall.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Only what you'd need to fix a broken machine. Day-to-day tools go in modules/home.
  environment.systemPackages = with pkgs; [
    curl
    git
    htop
    vim
    wget
  ];

  programs.zsh.enable = true;

  # Lets prebuilt Linux binaries that weren't built for Nix run (mise runtimes, Mason LSPs,
  # VS Code remote server). Without it they fail with "No such file or directory".
  programs.nix-ld.enable = true;
}
