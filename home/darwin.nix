{ lib, ... }: {
  imports = [ ./common.nix ];

  home = {
    homeDirectory = lib.mkDefault "/Users/bprins";
  };

  # opt in per machine via ./profiles/notes.nix
  targets.darwin.linkApps.enable = lib.mkDefault false;

  programs.zsh.profileExtra = ''
    if [ -x /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  '';

  # MacOS package is currently not available.
  # Only manage Ghostty configuration.
  programs.ghostty.package = null;
}
