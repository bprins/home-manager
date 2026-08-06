{ pkgs, ... }: {
  home.packages = with pkgs; [
    ansible
    ansible-lint
    uv
  ];

  programs.go.enable = true;
}
