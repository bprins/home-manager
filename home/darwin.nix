{ lib, pkgs, ... }: {
  imports = [ ./common.nix ];

  home = {
    homeDirectory = lib.mkDefault "/Users/bprins";

    packages = with pkgs; [
      caffeine
    ];
  };

  # Defaults back to true below stateVersion 25.11, we use copyApps
  targets.darwin.linkApps.enable = false;

  # Make sure Finder and Spotlight see home-manager installed Mac apps
  targets.darwin.copyApps.enable = true;

  programs.zsh.profileExtra = ''
    if [ -x /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  '';

  # MacOS package is currently not available; only manage Ghostty configuration
  programs.ghostty.package = null;
}
