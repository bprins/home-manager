{ pkgs, ... }: {
  home.packages = with pkgs; [
    obsidian
  ];

  programs.firefox.amoExtensions."clipper@obsidian.md" = "web-clipper-obsidian";
}
