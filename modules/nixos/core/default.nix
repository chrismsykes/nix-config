# Baseline that every machine gets. Keep it small; anything optional belongs in its own module.
{
  imports = [
    ./base.nix
    ./nix.nix
    ./user.nix
  ];
}
