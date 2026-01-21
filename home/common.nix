{ lib, pkgs, ... }:
let
  localConfigPath = /Users/bprins/.config/home-manager/local.nix;
in
{
  imports = lib.optional (builtins.pathExists localConfigPath) localConfigPath;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "claude-code"
  ];

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

  programs.claude-code.enable = true;

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

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    # pure preset
    settings = {
      format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$python$character";
      directory = {
        style = "blue";
      };
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
        vimcmd_symbol = "[❮](green)";
      };
      git_branch = {
        format = "[$branch]($style)";
        style = "bright-black";
      };
      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
        style = "cyan";
        conflicted = "";
        untracked = "";
        modified = "";
        staged = "";
        renamed = "";
        deleted = "";
        stashed = "≡";
      };
      git_state = {
        format = ''\([$state( $progress_current/$progress_total)]($style)\) '';
        style = "bright-black";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "yellow";
      };
      python = {
        format = "[$virtualenv]($style) ";
        style = "bright-black";
      };
    };
  };
}
