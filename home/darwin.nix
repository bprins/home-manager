{ lib, pkgs, ... }: {
  imports = [ ./common.nix ];

  home = {
    homeDirectory = "/Users/bprins";
  };
}
