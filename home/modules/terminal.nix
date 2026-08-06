{ pkgs, ... }: {
  home.packages = with pkgs; [
    tmux
  ];

  programs.ghostty = {
    enable = true;
    settings = import ./config/ghostty.nix;
  };
}
