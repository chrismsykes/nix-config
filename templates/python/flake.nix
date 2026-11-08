{
  description = "Python project";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { nixpkgs, ... }:
    let
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ] (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          # Add anything this project needs: compilers, CLIs, databases, C libraries...
          packages = with pkgs; [
            python3
            uv
            ruff
          ];

          env = {
            # Use the Python from this shell instead of letting uv download its own.
            UV_PYTHON = "${pkgs.python3}/bin/python3";
            UV_PYTHON_DOWNLOADS = "never";
          };

          # uv sync creates .venv; put its tools on PATH
          shellHook = ''
            export PATH="$PWD/.venv/bin:$PATH"
          '';
        };
      });
    };
}
