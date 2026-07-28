{ lib, pkgs, ... }: {
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "claude-code"
    "obsidian"
  ];

  programs.claude-code.enable = true;

  programs.gh = {
    enable = true;
    settings.git_protocol = "https";
    gitCredentialHelper = {
      enable = true;
      hosts = [ "https://github.com" "https://gist.github.com" ];
    };
  };

  home.packages = [ pkgs.obsidian ];
}
