{ lib, ... }: {
  imports = [ ./common.nix ];

  home = {
    homeDirectory = lib.mkDefault "/Users/bprins";
  };

  programs.zsh.profileExtra = ''
    if [ -x /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  '';

  # MacOS package is currently not available.
  # Only manage Ghostty configuration.
  programs.ghostty.package = null;
}
