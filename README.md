# nix-config

One flake for all my machines.

| Host          | What it is                                           | Status            |
|---------------|------------------------------------------------------|-------------------|
| `devbox`      | Main dev VM: repos, kubernetes, all secrets          | ready to install  |
| `devbox-lite` | Generic dev VM: no secrets, no k8s toolbox           | ready to install  |
| `gamer`       | Gaming PC, GTX 1080 Ti (NVIDIA `legacy_580` driver)  | ready to install  |
| `macbook`     | Intel T2 MacBook                                     | later, see `hosts/macbook/README.md` |

## Layout

```
flake.nix                 inputs (pinned in flake.lock) + the list of hosts
lib/default.nix           mkHost: turns hosts/<name>/ into a NixOS system
hosts/<name>/             ONLY what's unique to a machine: hardware, bootloader, which features it enables
modules/nixos/            system-level features (desktop, nvidia, gaming, docker, secrets...)
  core/                   baseline every machine gets (nix settings, user, ssh)
modules/home/             user-level features via home-manager (shell, git, dev tools)
secrets/                  sops-encrypted secrets, one file per host (safe to commit)
```

## Rules that keep it from turning into a mess

1. **Hosts choose, modules implement.** A host file should mostly be `my.something.enable = true;`.
   If you're writing real config in a host, it probably belongs in a module.
2. **Importing a module never changes anything.** Everything outside `core/` is behind a
   `my.<name>.enable` option. Every host imports every module, so there's no import spaghetti.
3. **System vs. user.** Services, drivers and anything that needs root go in `modules/nixos`.
   Your shell, CLI tools and dotfiles go in `modules/home`. Home modules never read NixOS config,
   so they can be reused on macOS or another distro later.
4. **Language toolchains go in project repos, not here.** See "Project environments" below.
   That keeps this config small and makes every project reproducible on any machine.
5. **Don't install things imperatively.** No `nix-env -i`, no `nix profile install`. To try something
   once, use `nix shell nixpkgs#foo`. To keep it, add it to a module.
6. **Stable base, unstable when needed.** Use `pkgs.foo` for stable and `pkgs.unstable.foo` for things
   that need to be current.

To add a feature: create `modules/nixos/foo.nix` (or `modules/home/foo.nix`) with a
`my.foo.enable` option, add it to that folder's `default.nix`, and enable it on the hosts that need it.

## Relationship to the chezmoi dotfiles (chrismsykes/dotfiles)

On NixOS hosts, home-manager manages everything chezmoi used to: zsh/omz/p10k, git, nvim,
tmux, btop, lazygit, ripgrep and ssh config. **Don't run chezmoi on a NixOS host.** Both tools
would fight over the same files. The chezmoi repo stays the source for macOS and Windows until
those machines move over.

| chezmoi                                  | here                                          |
|------------------------------------------|-----------------------------------------------|
| `.chezmoiexternal` omz/p10k downloads    | `modules/home/shell.nix` (nixpkgs packages)   |
| mise `[tools]` CLI list                  | `modules/home/cli.nix`                        |
| mise runtimes (go, node, java)           | per-project devShells (`templates/`); default go/node/jdk in `dev.nix` |
| `private_dot_config/nvim`                | `modules/home/files/nvim` (symlinked, editable) |
| `.p10k.zsh`                              | `modules/home/files/p10k.zsh`                 |
| apt / snap / PPA install scripts         | gone; packages are declared in Nix            |
| `ephemeral` / `personal` flags           | `devbox-lite` vs `devbox` (`my.dev`, `my.onepassword`) |

## Project environments (replaces mise)

Each repo pins its own toolchain in a `flake.nix` devShell. direnv loads it when you `cd` in
and unloads it when you leave.

```sh
cd ~/src/new-thing
nix flake init -t ~/nix-config#go      # or #node, #python
direnv allow                           # once per repo
git add flake.nix flake.lock .envrc    # commit all three
```

Edit `packages = [ ... ];` in the repo's flake.nix to add tools (protoc, postgresql, terraform...).
`nix flake update` in the repo bumps its toolchain. Run `nix flake show ~/nix-config` to see every
template. The default `go`/`nodejs`/JDK in `modules/home/dev.nix` are only for quick scripts
outside a project.

## Day-to-day

```sh
nh os switch          # build and activate this machine's config (repo at ~/nix-config)
nh os test            # activate without making it the boot default; a reboot rolls back
nix flake update      # update all inputs, then `nh os switch`. Commit flake.lock afterwards
nix fmt               # format every .nix file
nix flake check       # evaluate every host; run before committing
```

Every switch adds a boot menu entry, so a bad change is fixed by rebooting into the previous one.

Flakes only see files that git tracks. **If you add a file and the build says it doesn't exist,
run `git add` on it.**

## Try it first, without installing anything

On any Linux machine with Nix installed, this boots the config as a throwaway QEMU VM:

```sh
nixos-rebuild build-vm --flake .#devbox-lite && ./result/bin/run-*-vm
```

## Installing a host

### VMs (devbox, devbox-lite): nixos-anywhere, run from another machine

The disk layout lives in `modules/nixos/disk.nix` (disko). nixos-anywhere partitions the disk
from it, installs this flake over SSH, and writes the real hardware-configuration.nix back here.

1. Create the Proxmox VM: `q35`, **OVMF (UEFI)** + EFI disk with **"Pre-Enroll keys" unchecked**,
   Qemu Agent on, VirtIO SCSI disk (64 GB+), CPU type `host`, display **VirtIO-GPU**.
2. Boot the NixOS minimal ISO. In the Proxmox console, run `sudo passwd root` (temporary,
   installer only) and `ip a` to get its IP.
3. From a machine with this repo and Nix (**this erases the VM's disk**):
   ```sh
   nix run github:nix-community/nixos-anywhere -- \
     --flake .#devbox-lite \
     --generate-hardware-config nixos-generate-config ./hosts/devbox-lite/hardware-configuration.nix \
     --phases kexec,disko,install \
     root@<vm-ip>
   ```
4. Back in the Proxmox console (still the installer), set your real password, then reboot:
   ```sh
   sudo nixos-enter --root /mnt -c 'passwd chris'
   sudo reboot
   ```
   Detach the ISO in Proxmox so it boots from disk.
5. Commit the generated `hosts/<host>/hardware-configuration.nix` and push.
6. On the new machine: `git clone` this repo to `~/nix-config`. From then on, `nh os switch`.

The password never goes in git. `users.mutableUsers` is on, so `passwd` keeps working as usual.

### Bare metal (gamer): by hand

1. Boot the NixOS minimal ISO in UEFI mode.
2. Partition with labels `nixos` (ext4 root) and `boot` (FAT32 ESP), as in the NixOS manual.
   Mount them at `/mnt` and `/mnt/boot`.
3. `git clone <this repo> /mnt/home/chris/nix-config` (or copy it there).
4. `nixos-generate-config --root /mnt --show-hardware-config > /mnt/home/chris/nix-config/hosts/<host>/hardware-configuration.nix`
5. `nixos-install --flake /mnt/home/chris/nix-config#<host>`
6. Set your user's password: `nixos-enter --root /mnt -c 'passwd chris'`
7. Reboot, `sudo chown -R chris: ~/nix-config`, then commit the new hardware-configuration.nix.

`system.stateVersion` in each host is the release that host was **first installed** with. Never
change it, even when you move to a newer nixpkgs. It only controls how stateful data (databases
and similar) is handled, and changing it can break those migrations.

## Secrets (sops-nix)

Secrets are stored encrypted in `secrets/<host>.yaml`. Each machine decrypts its own file at boot
using its SSH host key. Plaintext only exists in `/run/secrets/` and never in the Nix store or in git.

One-time setup for `devbox`:

```sh
# 1. Your personal key, used to edit secrets. Back it up in a password manager.
mkdir -p ~/.config/sops/age && nix shell nixpkgs#age -c age-keygen -o ~/.config/sops/age/keys.txt
# 2. The devbox's key, derived from its SSH host key (run on the devbox after install):
nix shell nixpkgs#ssh-to-age -c sh -c 'ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub'
# 3. Put both public keys in .sops.yaml (there's a template), then create the file:
nix shell nixpkgs#sops -c sops secrets/devbox.yaml
# 4. Set my.secrets.enable = true in hosts/devbox/default.nix and declare secrets, e.g.:
#      sops.secrets.kubeconfig = { owner = config.my.user.name; path = "/home/chris/.kube/config"; };
```
