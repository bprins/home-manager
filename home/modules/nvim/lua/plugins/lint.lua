return {
  {
    "mfussenegger/nvim-lint",
    opts = function()
      local lint = require("lint")
      -- nvim-lint feeds the buffer to markdownlint-cli2 over stdin, so the tool
      -- looks for its config relative to the process cwd instead of the file.
      -- Run it from the file's own directory to pick up a project-local
      -- .markdownlint-cli2.yaml no matter where nvim was started.
      local base = lint.linters["markdownlint-cli2"]
      lint.linters["markdownlint-cli2"] = function()
        local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
        if vim.fn.isdirectory(dir) == 0 then
          dir = vim.fn.getcwd()
        end
        local linter = base
        if type(linter) == "function" then
          linter = linter()
        end
        return vim.tbl_extend("force", linter, { cwd = dir })
      end
    end,
  },
}
