{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
        url = "github:nix-community/home-manager/master";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
        url = "github:catppuccin/nix";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, catppuccin, ... }:
    let
      inherit (nixpkgs) lib;

      mkHome = system: modules: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = modules ++ [ catppuccin.homeModules.catppuccin ];
      };

      eachLinux = name: modules:
        builtins.listToAttrs (map (system: {
          name = "${name}-${lib.removeSuffix "-linux" system}";
          value = mkHome system modules;
        }) [ "x86_64-linux" "aarch64-linux" ]);

      mkDarwin = name: modules: { ${name} = mkHome "aarch64-darwin" modules; };
    in {
      homeConfigurations =
        eachLinux "bprins-linux" [ ./home/linux.nix ]
        // mkDarwin "bprins-macbookair" [
          ./home/darwin.nix
          ./home/profiles/ai-tools.nix
          ./home/profiles/github.nix
          ./home/profiles/notes.nix
        ]
        // mkDarwin "bprins-macmini" [
          ./home/darwin.nix
          ./home/profiles/ai-tools.nix
          ./home/profiles/github.nix
          ./home/profiles/notes.nix
        ]
        // mkDarwin "bprins-macbookpro" [
          ./home/darwin.nix
        ];
    };
}
