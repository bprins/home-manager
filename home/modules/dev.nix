{ pkgs, ... }: {
  home.packages = with pkgs; [
    gnumake
    uv
    yamllint
  ];

  programs.go.enable = true;
}
