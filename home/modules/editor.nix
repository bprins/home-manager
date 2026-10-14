{ config, pkgs, ... }: {
  # language servers, formatters and linters driven by neovim
  home.packages = with pkgs; [
    ansible-language-server
    gofumpt
    gopls
    gotools
    lua-language-server
    luajitPackages.luarocks
    markdown-toc
    markdownlint-cli2
    marksman
    prettier
    pyright
    ruff
    shfmt
    stylua
    taplo
    tree-sitter
    yaml-language-server
  ];

  # LazyVim manages its own colorscheme; this would only add a second plugin copy lazy.nvim warns about.
  catppuccin.nvim.enable = false;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    sideloadInitLua = true;
    withRuby = false;
    withPython3 = false;
  };

  # Out-of-store so lazy.nvim can write lazy-lock.json and edits apply without a switch.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.repoPath}/home/modules/nvim";
}
