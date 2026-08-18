{ pkgs, ... }: {
  home.packages = with pkgs; [
    obsidian
  ];

  # darwin-only: without it obsidian is only a store path
  targets.darwin.copyApps.enable = true;
}
