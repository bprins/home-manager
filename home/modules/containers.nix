{ pkgs, ... }: {
  home.packages = with pkgs; [
    kubectl
    kubernetes-helm
    kustomize
    podman
    podman-compose
    popeye
    skopeo
  ];

  programs.k9s.enable = true;
}
