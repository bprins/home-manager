{ pkgs, ... }: {
  home.packages = with pkgs; [
    k3d
    podman
    podman-compose
    popeye
  ];

  programs.k9s.enable = true;

  programs.zsh.initContent = ''
    export CONTAINER_CONNECTION=podman-machine-default-root
    export DOCKER_HOST=$(podman system connection ls --format '{{if eq .Name "podman-machine-default-root"}}{{.URI}}{{end}}' 2>/dev/null)
    export DOCKER_SOCK=/run/podman/podman.sock
  '';
}
