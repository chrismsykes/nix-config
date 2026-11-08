# macbook (Intel, T2 chip). Not set up yet

This folder is a placeholder. Nothing in the flake references it yet.

When you're ready:

1. Add `nixos-hardware.url = "github:NixOS/nixos-hardware";` to the flake inputs.
2. Write `default.nix` the same way as the other hosts, and import
   `inputs.nixos-hardware.nixosModules.apple-t2` (patched kernel, keyboard/trackpad, audio).
3. Add the t2linux binary cache (see https://wiki.t2linux.org/distributions/nixos/) so you
   don't compile the patched kernel yourself.
4. Wi-Fi/Bluetooth firmware has to be extracted from macOS first. Follow the t2linux
   firmware guide before you wipe macOS.
5. Add `macbook = myLib.mkHost { hostname = "macbook"; };` to `flake.nix`.

Another option: keep macOS and use only `modules/home` through standalone home-manager or
nix-darwin. The home modules don't depend on NixOS, so that works without a rewrite.
