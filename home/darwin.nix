{ lib, pkgs, ... }: {
  imports = [ ./common.nix ];

  home = {
    homeDirectory = "/Users/bprins";
  };

  # MacOS package is currently not available.
  # Only manage Ghostty configuration.
  programs.ghostty.package = null;
}
