{ pkgs, ... }: {
  home.packages = with pkgs; [ uv ];

  programs.go.enable = true;
}
