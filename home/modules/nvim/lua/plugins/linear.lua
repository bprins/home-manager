-- Open a team's issues directly, skipping the `:LinearTeams` picker.
-- The plugin supports a team filter but only exposes it behind the picker,
-- so resolve the team name to an id first.
local function open_team_issues(name)
  local api = require("linear.api")
  local pickers = require("linear.ui.telescope.pickers")

  api.get_teams(function(data, err)
    if err or not (data and data.teams and data.teams.nodes) then
      vim.notify("linear.nvim: could not fetch teams" .. (err and (": " .. err) or ""), vim.log.levels.ERROR)
      return
    end

    local needle = name:lower()
    for _, team in ipairs(data.teams.nodes) do
      if team.name:lower() == needle or team.name:lower():find(needle, 1, true) then
        pickers.issues({
          filter = { team = { id = { eq = team.id } } },
          prompt_title = "Issues in " .. team.name,
        })
        return
      end
    end

    vim.notify("linear.nvim: team '" .. name .. "' not found", vim.log.levels.WARN)
  end)
end

return {
  {
    "JoeyMcKenzie/linear.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    -- NOTE: these are the commands actually registered in lua/linear/commands.lua.
    -- The upstream README documents several that don't exist (LinearIssuesAll,
    -- LinearIssuesTeam, LinearTestAuth, LinearSetContext/Context/ClearContext).
    cmd = {
      "LinearIssues",
      "LinearSearch",
      "LinearBoards",
      "LinearTeams",
      "LinearCycle",
      "LinearCurrent",
      "LinearBranch",
      "LinearProjects",
      "LinearViews",
      -- defined in config() below
      "LinearTeamIssues",
    },
    keys = {
      {
        "<leader>ii",
        function()
          open_team_issues("Infra")
        end,
        desc = "Linear issues (Infra team)",
      },
      {
        "<leader>im",
        "<cmd>LinearIssues<cr>",
        desc = "Linear issues (assigned to me)",
      },
      { "<leader>is", "<cmd>LinearSearch<cr>", desc = "Linear search" },
      { "<leader>ib", "<cmd>LinearBranch<cr>", desc = "Linear branch from issue" },
    },
    opts = {
      -- api_key read from $LINEAR_API_KEY or ~/.config/linear/api_key
      branch = {
        -- conventional commit types, ordered by frequency in onedr0p/home-ops
        scopes = { "fix", "feat", "chore", "ci", "refactor", "docs" },
        lowercase_identifier = true,
      },
      ui = {
        telescope = {
          layout = "horizontal",
          preview_comment_limit = 5,
        },
        statusline = {
          show_title = false,
          title_max_length = 30,
        },
      },
    },
    config = function(_, opts)
      require("linear").setup(opts)

      -- Upstream closes the telescope prompt and calls vim.ui.select in the same
      -- call stack (ui/telescope/actions.lua:178). fzf-lua's ui.select runs fzf in
      -- a terminal buffer and relies on `startinsert`, which races telescope's
      -- insert-mode teardown -- so the scope prompt intermittently opens in normal
      -- mode and swallows j/k. Deferring a tick lets the teardown settle first.
      local linear_actions = require("linear.ui.telescope.actions")
      linear_actions.create_branch = function(prompt_bufnr)
        local entry = require("telescope.actions.state").get_selected_entry()
        if not (entry and entry._data) then
          return
        end

        local issue = entry._data
        require("telescope.actions").close(prompt_bufnr)

        vim.schedule(function()
          require("linear.branch").create_branch_for_issue(issue)
        end)
      end

      -- Upstream always asks "Include title in branch name?" (branch.lua:120).
      -- Always include it and drop that second prompt, leaving only the scope
      -- picker. Covers both <C-g> and :LinearBranch, which share this function.
      local branch = require("linear.branch")
      branch.create_branch_for_issue = function(issue, on_complete)
        local scopes = opts.branch.scopes

        vim.ui.select(scopes, { prompt = "Select branch type:" }, function(scope)
          if not scope then
            if on_complete then
              on_complete()
            end
            return
          end

          local branch_name = branch.generate_branch_name(issue, scope, true)

          branch.create_and_checkout(branch_name, function(success, err)
            if success then
              require("linear.context").set(issue.identifier)
              require("linear.statusline").clear_cache()
              vim.notify("Created and switched to branch: " .. branch_name, vim.log.levels.INFO)
            else
              vim.notify(err or "Failed to create branch", vim.log.levels.ERROR)
            end

            if on_complete then
              on_complete()
            end
          end)
        end)
      end

      vim.api.nvim_create_user_command("LinearTeamIssues", function(cmd_opts)
        open_team_issues(cmd_opts.args ~= "" and cmd_opts.args or "Infra")
      end, {
        desc = "Browse a Linear team's issues (defaults to Infra)",
        nargs = "?",
      })
    end,
  },
}
