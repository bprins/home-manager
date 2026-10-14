# home-manager

[home-manager](https://github.com/nix-community/home-manager) configuration for managing my user environment.

## Bootstrap

Clone this repository to `~/code/home-manager`. Some config (e.g. `~/.config/nvim`) is symlinked straight into the checkout, so a different location needs `repoPath` overridden for that host in `flake.nix`.

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
nix run home-manager/master -- switch --flake .#<host>
```

After the first switch `home-manager` is on the `PATH`.

### Binary caches

Append to `/etc/nix/nix.custom.conf`:

```
extra-substituters = https://bprins.cachix.org https://catppuccin.cachix.org
extra-trusted-public-keys = bprins.cachix.org-1:5aeG+RRkCdnpPoX1hibdT6XCaVeNCKGQ/+YXQdc2lyU= catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU=
```

Restart the daemon and confirm both caches are listed:

```sh
sudo launchctl kickstart -k system/systems.determinate.nix-daemon
nix config show | grep substituters
```

## Usage

MacOS, per machine:

```sh
home-manager switch --flake .#bprins-macbookair
home-manager switch --flake .#bprins-macmini
home-manager switch --flake .#bprins-macbookpro
```

Linux:

```sh
home-manager switch --flake .#bprins-linux-$(uname -m)
```

When using a `~/.config/home-manager/local.nix` to maintain local overrides add `--impure` to the `home-manager switch` command.

## Updates

Renovate refreshes `flake.lock` every weekend.

Update `flake.lock` manually:

```sh
nix --option commit-lockfile-summary "chore: update flake.lock" flake update --commit-lock-file
```

Preview what a lock change moves before switching:

```sh
nvd diff ~/.local/state/home-manager/gcroots/current-home \
  "$(nix build .#homeConfigurations.bprins-macbookair.activationPackage --no-link --print-out-paths)"
```

### Neovim plugins

`~/.config/nvim` links into this checkout, so lazy.nvim writes `home/modules/nvim/lazy-lock.json` directly in the repo. Renovate doesn't track it.

Update on one machine:

1. Run `:Lazy sync` and check nothing breaks (`:Lazy restore` rolls back to the lockfile).
2. Commit the lockfile on its own as `chore(neovim): update lazy-lock.json`.

On the other machines, `git pull` and run `:Lazy restore`, since pulling alone doesn't move installed plugins to the locked commits.

## Housekeeping

Reclaim disk space by removing generations older than 30 days:

```sh
home-manager expire-generations "-30 days"
nix profile wipe-history --older-than 30d --profile ~/.local/state/nix/profiles/profile
nix store gc
```
