{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Only notifies: the upgrade replaces the root-owned Nix daemon, so it needs sudo.
  checkDeterminateNix = pkgs.writeShellScript "check-determinate-nix" ''
    output=$(/usr/local/bin/determinate-nixd version) || exit 1
    current=$(sed -n 's/^Determinate Nixd daemon version: //p' <<<"$output")
    latest=$(sed -n 's/^Latest version: //p' <<<"$output")
    if [ -n "$latest" ] && [ "$current" != "$latest" ]; then
      /usr/bin/osascript -e "display notification \"$current → $latest: run sudo determinate-nixd upgrade\" with title \"Determinate Nix update available\""
    fi
  '';
in
{
  home.homeDirectory = lib.mkDefault "/Users/bprins";

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

  launchd.agents.check-determinate-nix = {
    enable = true;
    config = {
      ProgramArguments = [ "${checkDeterminateNix}" ];
      # Mondays 10:00; launchd runs a missed slot on wake.
      StartCalendarInterval = [
        {
          Weekday = 1;
          Hour = 10;
          Minute = 0;
        }
      ];
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/check-determinate-nix.log";
    };
  };
}
