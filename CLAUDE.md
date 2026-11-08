# nix-config

NixOS flake for several machines. README.md describes the layout and conventions, and they are binding:

- Hosts (`hosts/<name>/default.nix`) only set hardware, bootloader, stateVersion and `my.*.enable` flags.
- Every optional feature is a module with a `my.<name>.enable` option, listed in its folder's `default.nix`.
- `modules/home` must not use `osConfig`. Keep it portable to standalone home-manager and nix-darwin.
- Use `config.my.user.name` instead of hardcoding the username.
- Never change a host's `system.stateVersion`.
- Look up option and package names with the nixos MCP server; don't rely on memory. The base is nixos-26.05.
- New files must be `git add`ed before `nix flake check` can see them.
