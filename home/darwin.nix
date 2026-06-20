{ lib, pkgs, ... }: {
  imports = [ ./common.nix ];

  home = {
    homeDirectory = "/Users/bprins";
  };

  programs.zsh.profileExtra = "eval $(/opt/homebrew/bin/brew shellenv)";

  # MacOS package is currently not available.
  # Only manage Ghostty configuration.
  programs.ghostty.package = null;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "claude-code"
    "obsidian"
  ];
  programs.claude-code.enable = true;
}
