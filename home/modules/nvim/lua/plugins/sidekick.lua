-- sidekick.nvim overrides for running Pi inside an OpenShell sandbox.
--
-- The `lazyvim.plugins.extras.ai.sidekick` extra is imported in config/lazy.lua.
-- Two adjustments are needed for the sandbox; both are harmless on the host.
return {
  {
    "folke/sidekick.nvim",
    keys = {
      -- Pick claude when it is installed, otherwise the picker.
      -- Inside an OpenShell sandbox (OPENSHELL_SANDBOX=1) it chooses claude
      -- if CLAUDE_CODE_OAUTH_TOKEN is set, otherwise pi.
      {
        "<leader>aa",
        function()
          local tool = vim.fn.executable("claude") == 1 and "claude" or nil
          if vim.env.OPENSHELL_SANDBOX == "1" then
            tool = vim.env.CLAUDE_CODE_OAUTH_TOKEN and "claude" or "pi"
          end
          require("sidekick.cli").toggle({ name = tool, focus = true })
        end,
        desc = "Sidekick Toggle CLI",
      },
    },
    opts = {
      -- 1. Next Edit Suggestions require a GitHub Copilot subscription and
      --    wire up the copilot LSP server. The sandbox's network policy does
      --    not allow Copilot endpoints, and NES is not why sidekick is here —
      --    the CLI integration is. Disabling it leaves the CLI half untouched.
      nes = { enabled = false },

      cli = {
        tools = {
          -- 2. sidekick ships `cmd = { "pi" }`, i.e. bare pi with no provider
          --    or model. Pi then defaults to provider "google", fails to
          --    resolve it, and reaches for pi.dev:443 — which the sandbox
          --    policy denies. Pi RETRIES rather than failing, so it hangs with
          --    no error, and nothing in the UI suggests a policy problem.
          --
          --    deepseek-flash is DeepSeek V4.1 Flash. Pi's bundled catalog
          --    stops at deepseek-v4-flash, so it warns "not found ... using
          --    custom model id" and passes it through — cosmetic, the request
          --    is correct.
          pi = {
            cmd = { "pi", "--provider", "deepseek", "--model", "deepseek-flash" },
          },
        },
      },
    },
  },
}
