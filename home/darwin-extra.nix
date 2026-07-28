{ lib, pkgs, ... }: {
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "claude-code"
    "obsidian"
  ];

  programs.claude-code.enable = true;

  home.packages = [ pkgs.obsidian ];
}
