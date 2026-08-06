{ ... }: {
  programs.gh = {
    enable = true;
    settings.git_protocol = "https";
    gitCredentialHelper = {
      enable = true;
      hosts = [ "https://github.com" "https://gist.github.com" ];
    };
  };
}
