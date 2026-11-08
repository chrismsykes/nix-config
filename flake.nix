{
  description = "Chris's NixOS machines";

  inputs = {
    # Stable base. Bump this (and home-manager below) together, once per release (every May/Nov).
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Escape hatch for fast-moving tools: use `pkgs.unstable.<name>` anywhere.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disk layouts as code; used by nixos-anywhere at install time.
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Prebuilt Rex releases. `nix flake update rex` moves to the newest snapshot.
    rex = {
      url = "https://pkgs.superlogical.com/rex/nix/snapshot.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      myLib = import ./lib { inherit inputs; };
    in
    {
      nixosConfigurations = {
        devbox = myLib.mkHost { hostname = "devbox"; };
        devbox-lite = myLib.mkHost { hostname = "devbox-lite"; };
        gamer = myLib.mkHost { hostname = "gamer"; };
        # macbook: not wired up yet, see hosts/macbook/README.md
      };

      # Starter devShells for projects: `nix flake init -t ~/nix-config#go`
      templates = {
        go = {
          path = ./templates/go;
          description = "Go project devShell";
        };
        node = {
          path = ./templates/node;
          description = "Node.js project devShell";
        };
        python = {
          path = ./templates/python;
          description = "Python project devShell (uv)";
        };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
