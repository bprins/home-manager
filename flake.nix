{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
        url = "github:nix-community/home-manager/master";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      inherit (nixpkgs) lib;

      mkHome = system: modules: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        inherit modules;
      };

      eachLinux = name: modules:
        builtins.listToAttrs (map (system: {
          name = "${name}-${lib.removeSuffix "-linux" system}";
          value = mkHome system modules;
        }) [ "x86_64-linux" "aarch64-linux" ]);
    in {
      homeConfigurations =
        eachLinux "bprins-linux" [ ./home/linux.nix ]
        // {
          bprins-darwin = mkHome "aarch64-darwin" [ ./home/darwin.nix ];
        };
    };
}
