{ pkgs, ... }: {
  home.packages = with pkgs; [
    tmux
  ];

  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 11;
      keybind = [ "super+shift+r=reset" ];
    };
  };
}
