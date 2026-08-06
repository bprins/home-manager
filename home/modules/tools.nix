{ config, pkgs, ... }: {
  # eza resolves its config dir per platform and ignores XDG_CONFIG_HOME
  home.sessionVariables.EZA_CONFIG_DIR = "${config.xdg.configHome}/eza";

  # aliases live next to the tool they point at; zsh merges them across modules
  programs.zsh.shellAliases = {
    cat = "bat";
    man = "batman";
  };

  programs.fd.enable = true;
  programs.lf.enable = true;
  programs.ripgrep.enable = true;

  programs.bat = {
    enable = true;
    config = {
      paging = "never";
      style = "plain";
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batgrep
      batman
      batwatch
    ];
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--color=auto"
    ];
  };

  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };
}
