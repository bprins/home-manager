# home-manager

[home-manager](https://github.com/nix-community/home-manager) configuration for managing my user environment.

## Bootstrap

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
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

## Housekeeping

Reclaim disk space by removing generations older than 30 days:

```sh
home-manager expire-generations "-30 days"
nix profile wipe-history --older-than 30d --profile ~/.local/state/nix/profiles/profile
nix store gc
```
