{ ... }: {
  programs.atuin.enable = true;
  programs.mise.enable = true;
  programs.zoxide.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    historyWidget = {
      command = "";
    };
  };

  programs.starship = {
    enable = true;
    settings = import ./config/starship.nix;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
  };
}
