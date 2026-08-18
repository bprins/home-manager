{ lib, ... }: {
  imports = [ ./common.nix ];

  home = {
    homeDirectory = lib.mkDefault "/Users/bprins";
  };

  # Defaults back to true below stateVersion 25.11, we use copyApps
  targets.darwin.linkApps.enable = false;

  programs.zsh.profileExtra = ''
    if [ -x /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  '';

  # MacOS package is currently not available.
  # Only manage Ghostty configuration.
  programs.ghostty.package = null;
}
