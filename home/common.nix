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
      k3d
      lua-language-server
      luajitPackages.luarocks
      markdownlint-cli2
      marksman
      podman
      podman-compose
      prettier
      stylua
      tmux
      tree-sitter
      uv
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
    initContent = ''
      export CONTAINER_CONNECTION=podman-machine-default-root
      export DOCKER_HOST=$(podman system connection ls --format '{{if eq .Name "podman-machine-default-root"}}{{.URI}}{{end}}' 2>/dev/null)
      export DOCKER_SOCK=/run/podman/podman.sock
    '';
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "127.0.0.1" = {
        identityFile = "~/.local/share/containers/podman/machine/machine";
      };
      "*" = {
        addKeysToAgent = "yes";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  programs.atuin.enable = true;

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

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
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
