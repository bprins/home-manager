{ lib, ... }:
let
  homeEnv = builtins.getEnv "HOME";
  localConfigPath = "${homeEnv}/.config/home-manager/local.nix";
  # getEnv returns "" under pure evaluation, which would skip local.nix silently
  pureEval = homeEnv == "";
in
{
  imports = [
    ./modules/containers.nix
    ./modules/dev.nix
    ./modules/editor.nix
    ./modules/git.nix
    ./modules/shell.nix
    ./modules/ssh.nix
    ./modules/terminal.nix
    ./modules/tools.nix
  ]
  ++
    lib.warnIf pureEval
      "local.nix overrides skipped: HOME is unset under pure evaluation, pass --impure to apply them"
      (lib.optional (!pureEval && builtins.pathExists localConfigPath) (/. + localConfigPath));

  # allowUnfreePredicate is a function, so it cannot merge across modules and has to
  # live in one place. Allowing a package here does not install it; the profile that
  # wants it still has to pull it in.
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "claude-code"
      "obsidian"
    ];

  home = {
    username = lib.mkDefault "bprins";
    homeDirectory = lib.mkOptionDefault "/home/bprins";

    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "mauve";
  };
}
