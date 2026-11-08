{ inputs }:
{
  # Build one NixOS machine from hosts/<hostname>/.
  # Every host gets the full module library; modules do nothing until a host enables them.
  mkHost =
    {
      hostname,
      system ? "x86_64-linux",
      extraModules ? [ ],
    }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        { nixpkgs.hostPlatform = system; }
        { networking.hostName = hostname; }
        inputs.home-manager.nixosModules.home-manager
        inputs.sops-nix.nixosModules.sops
        ../modules/nixos
        ../hosts/${hostname}
      ]
      ++ extraModules;
    };
}
