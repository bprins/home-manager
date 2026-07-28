{ lib, ... }: {
  imports = [ ./common.nix ];

  home = {
    homeDirectory = lib.mkDefault "/Users/bprins";
  };

  programs.zsh.profileExtra = "eval $(/opt/homebrew/bin/brew shellenv)";

  # MacOS package is currently not available.
  # Only manage Ghostty configuration.
  programs.ghostty.package = null;
}
