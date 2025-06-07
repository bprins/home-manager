# home-manager

[home-manager](https://github.com/nix-community/home-manager) configuration for managing my user environment.

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

```

MacOS:

```sh
home-manager switch --flake .#bprins-darwin
```

Linux:

```sh
home-manager switch --flake .#bprins-linux
```
