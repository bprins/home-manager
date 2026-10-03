{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
in
{
  home.packages = with pkgs; [
    tmux
  ];

  programs.ghostty = {
    enable = true;
    # pkgs.ghostty is Linux-only; ghostty-bin repackages the official DMG
    package = if isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    settings = {
      font-size = 11;
      keybind = [ "super+shift+r=reset" ];
      # Updates come through flake.lock; Sparkle can't write to the Nix store
      auto-update = lib.mkIf isDarwin "off";
    };
  };
}
