-- Using this because it enables me to make commands to disable certain formatters e.g. rubocop
local conform_config = {
  default_format_opts = {
    timeout_ms = 3000,
    async = false,
    quiet = false,
    lsp_fallback = true,
  },
  formatters_by_ft = {
    python = { "black", "isort" },
    go = { "goimports", "gofmt", "golines" },
    lua = { "stylua" },
    sql = { "sqlfluff" },
    ruby = { "rubocop" },
    eruby = { "erb-format" },
    sh = { "shfmt" },
  },
  formatters = {
    injected = { options = { ignore_errors = true } },
    golines = { prepend_args = { "--no-reformat-tags", "-m", "120", "--base-formatter=gofmt" } },
    -- https://github.com/stevearc/conform.nvim/issues/369
    rubocop = {
      options = { ignore_errors = true },
      args = { "--server", "--auto-correct-all", "--stderr", "--force-exclusion", "--stdin", "$FILENAME" },
    },
  },
}
return {
  {
    -- Responsible for installing Language Servers
    -- Use :MasonLog to see logs
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "shellcheck",
        "shellharden",
        "bash-language-server",
        -- Ruby
        "erb-lint",
        "erb-formatter",
        "rubocop",
      })
    end,
  },
  {
    -- Responsible for custom configuration for the language server if needed
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
      },
    },
    opts = {
      autoformat = false, -- format with <leader>f
      servers = {
        lua_ls = {
          -- Lua = {
          --   -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
          --   diagnostics = { globals = { "vim" }, disable = { "missing-fields" } },
          -- },
        },
        gopls = {
          settings = {
            gopls = {
              buildFlags = { "-tags=integration" },
            },
          },
        },
        ruby_lsp = {},
        rubocop = {
          on_new_config = function(config, root_dir)
            -- Ensure config.cmd is not nil
            if config.cmd then
              -- Add additional arguments to the cmd array
              table.insert(config.cmd, "--config")
              table.insert(config.cmd, vim.fn.expand("~/.config/rubocop/.rubocop.yml"))
            end
          end,
        },
        sorbet = {},
      },
    },
  },
  -- Responsible for automatic formatting, if you press <leader>f this is run
  -- Check formatters here: https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
  {
    "stevearc/conform.nvim",
    opts = function()
      return conform_config
    end,
    keys = function()
      return {
        {
          "<space>ci",
          function()
            local formatters = conform_config.formatters_by_ft.ruby
            local rubocop_index = nil
            for i = 1, #formatters do
              if formatters[i] == "rubocop" then
                rubocop_index = i
                break
              end
            end
            if rubocop_index then
              vim.notify("Rubocop formatter disabled", vim.log.levels.Info)
              table.remove(formatters, rubocop_index)
            else
              table.insert(formatters, "rubocop")
              vim.notify("Rubocop formatter enabled", vim.log.levels.Info)
            end
          end,
          desc = "[C]ode [i] Robocop formatter remove",
        },
      }
    end,
  },
  -- linting, gives errors and warnings
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        go = { "golangcilint" },
        markdown = { "markdownlint" }, -- configs live in ~/.markdownlintrc
        proto = { "buf_lint" },
        dockerfile = { "hadolint" },
      },
    },
  },
}
