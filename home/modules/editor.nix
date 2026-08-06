{ pkgs, ... }: {
  # language servers, formatters and linters driven by neovim
  home.packages = with pkgs; [
    lua-language-server
    luajitPackages.luarocks
    markdownlint-cli2
    marksman
    prettier
    stylua
    tree-sitter
    yaml-language-server
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    sideloadInitLua = true;
    withRuby = false;
    withPython3 = false;
  };
}
