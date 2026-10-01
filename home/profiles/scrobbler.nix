{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.multi-scrobbler ];

  launchd.agents.multi-scrobbler = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [ (lib.getExe pkgs.multi-scrobbler) ];
      EnvironmentVariables = {
        CONFIG_DIR = "${config.xdg.configHome}/multi-scrobbler";
        DATA_DIR = "${config.xdg.dataHome}/multi-scrobbler";
      };
      RunAtLoad = true;
      KeepAlive.SuccessfulExit = false;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/multi-scrobbler.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/multi-scrobbler.log";
    };
  };
}
