{ lib, pkgs, ... }: {
  imports = [ ./common.nix ];

  home = {
    homeDirectory = "/Users/bprins";
  };

  # MacOS package is currently not available.
  # Only manage Ghostty configuration.
  programs.ghostty.package = null;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "claude-code"
  ];
  programs.claude-code.enable = true;
}
