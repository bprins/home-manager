{ ... }: {
  programs.claude-code.enable = true;

  # osh <sandbox> [command...]: SSH into an OpenShell sandbox
  programs.zsh.initContent = ''
    osh() { ssh -t -F =(openshell sandbox ssh-config "$1") "openshell-$1.default" "''${@:2}"; }
  '';
}
