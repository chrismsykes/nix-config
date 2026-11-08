# Every NixOS module in the repo. Importing a module must never change a machine by itself:
# anything beyond ./core sits behind a `my.<name>.enable` option that hosts turn on.
{
  imports = [
    ./core
    ./containers.nix
    ./desktop.nix
    ./gaming.nix
    ./home-manager.nix
    ./nvidia.nix
    ./onepassword.nix
    ./secrets.nix
    ./vm-guest.nix
  ];
}
