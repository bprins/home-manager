{ lib, pkgs, ... }:
let
  localConfigPath = /Users/bprins/.config/home-manager/local.nix;
in
{
  imports = lib.optional (builtins.pathExists localConfigPath) localConfigPath;

  home = {
    packages = with pkgs; [
      ansible
      ansible-lint
      lua-language-server
      luajitPackages.luarocks
      markdownlint-cli2
      marksman
      prettier
      stylua
      tmux
      tree-sitter
      yaml-language-server
    ];

    username = "bprins";
    homeDirectory = lib.mkDefault "/home/bprins";

    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "bobby.prins@gmail.com";
        name = "Bobby Prins";
      };
      init = {
        defaultBranch = "main";
      };
      merge = {
        conflictStyle = "diff3";
        tool = "meld";
      };
      pull = {
        rebase = true;
      };
    };
    lfs.enable = true;
  };
  programs.diff-so-fancy = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.neovim.enable = true;
  programs.fd.enable = true;
  programs.ripgrep.enable = true;
  programs.lazygit.enable = true;

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

  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
      paging = "never";
      style = "plain";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  programs.go.enable = true;

  programs.lf.enable = true;

  programs.zoxide.enable = true;

  programs.ghostty = {
    enable = true;
    settings = import ./config/ghostty.nix;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = import ./config/starship.nix;
  };
}
