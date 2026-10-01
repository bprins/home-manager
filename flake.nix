{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # No nixpkgs follows: builds against catppuccin's own pin are what
    # catppuccin.cachix.org holds, so CI can fetch whiskers instead of compiling it.
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      catppuccin,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      linuxSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      systems = linuxSystems ++ [ "aarch64-darwin" ];

      forAllSystems = f: lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});

      mkHome =
        system: modules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./home/common.nix
            catppuccin.homeModules.catppuccin
          ]
          ++ modules;
        };

      # `system` is declared here rather than read back off the built config, so
      # that `checks` can select this system's hosts without evaluating the rest.
      hosts =
        lib.listToAttrs (
          map (system: {
            name = "bprins-linux-${lib.removeSuffix "-linux" system}";
            value = {
              inherit system;
              modules = [ ];
            };
          }) linuxSystems
        )
        // {
          bprins-macbookair = {
            system = "aarch64-darwin";
            modules = [
              ./home/darwin.nix
              ./home/profiles/ai-tools.nix
              ./home/profiles/browser.nix
              ./home/profiles/displays.nix
              ./home/profiles/github.nix
              ./home/profiles/notes.nix
              ./home/profiles/media.nix
            ];
          };
          bprins-macmini = {
            system = "aarch64-darwin";
            modules = [
              ./home/darwin.nix
              ./home/profiles/ai-tools.nix
              ./home/profiles/browser.nix
              ./home/profiles/displays.nix
              ./home/profiles/github.nix
              ./home/profiles/notes.nix
              ./home/profiles/media.nix
              ./home/profiles/scrobbler.nix
            ];
          };
          bprins-macbookpro = {
            system = "aarch64-darwin";
            modules = [ ./home/darwin.nix ];
          };
        };
    in
    {
      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);

      checks = forAllSystems (
        pkgs:
        {
          lint =
            pkgs.runCommand "lint"
              {
                nativeBuildInputs = with pkgs; [
                  deadnix
                  statix
                  nixfmt
                ];
              }
              ''
                cd ${self}
                deadnix --fail .
                statix check .
                find . -name '*.nix' -exec nixfmt --check {} +
                touch $out
              '';
        }
        // lib.mapAttrs' (
          name: _: lib.nameValuePair "home-${name}" self.homeConfigurations.${name}.activationPackage
        ) (lib.filterAttrs (_: h: h.system == pkgs.stdenv.hostPlatform.system) hosts)
      );

      homeConfigurations = lib.mapAttrs (_: h: mkHome h.system h.modules) hosts;
    };
}
