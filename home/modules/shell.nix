{ ... }: {
  programs.atuin.enable = true;
  programs.zoxide.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    historyWidget = {
      command = "";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = import ./config/starship.nix;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
  };
}
