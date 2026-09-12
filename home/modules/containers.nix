{ pkgs, ... }: {
  home.packages = with pkgs; [
    podman
    podman-compose
    popeye
  ];

  programs.k9s.enable = true;
}
