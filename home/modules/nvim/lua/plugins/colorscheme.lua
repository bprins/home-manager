return {
  { "catppuccin/nvim", name = "catppuccin", opts = { flavour = "mocha" } },
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } },
  -- catppuccin's FloatBorder is crust, which makes lazygit's inactive borders and panel numbers invisible
  { "folke/snacks.nvim", opts = { lazygit = { theme = { inactiveBorderColor = { fg = "Comment" } } } } },
}
