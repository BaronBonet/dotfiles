-- Using this because it enables me to make commands to disable certain formatters e.g. rubocop
local conform_config = {
  default_format_opts = {
    timeout_ms = 3000,
    async = false,
    quiet = false,
    lsp_fallback = true,
  },
  formatters_by_ft = {
    python = { "ruff", "isort" },
    go = { "goimports", "gofmt", "golines" },
    lua = { "stylua" },
    sql = { "sqlfluff" },
    ruby = { "rubocop" },
    eruby = { "erb-format" },
    sh = { "shfmt" },
    d2 = { "d2" },
    terraform = { "terraform_fmt" },
    tf = { "terraform_fmt" },
    ["terraform-vars"] = { "terraform_fmt" },
  },
  formatters = {
    injected = { options = { ignore_errors = true } },
    golines = { prepend_args = { "--no-reformat-tags", "-m", "120", "--base-formatter=gofmt" } },
    -- https://github.com/stevearc/conform.nvim/issues/369
    rubocop = {
      options = { ignore_errors = true },
      args = { "--server", "--auto-correct-all", "--stderr", "--force-exclusion", "--stdin", "$FILENAME" },
    },
    sqlfluff = {
      args = { "fix", "--dialect=postgres" },
      stdin = false,
      require_cwd = false,
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
        "tflint",
        "sqlfluff",
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
        ruby_lsp = {
          -- Note if you get an error about ruby-lsp not working that is because it might not be installed for
          -- The specific ruby version you are using after configuring the local version of ruby e.g.
          -- asdf local ruby 3.3.4
          -- you'll have to install ruby-lsp for that version e.g.
          -- asdf exec gem install ruby-lsp
          -- TODO: change this to run through bin/ruby-lsp so you need to run the binstubs all command then the lsp is run through the binary in the bin
          cmd = { "sh", "-c", "asdf exec ruby-lsp" },
        },
        rubocop = {
          -- TODO: this will fail miserably in places
          cmd = { "bin/rubocop", "--lsp" },
          -- cmd = { "asdf", "exec", "rubocop", "--lsp" },
          on_new_config = function(config, root_dir)
            -- Ensure config.cmd is not nil
            if config.cmd then
              local project_rubocop_config = root_dir .. "/.rubocop.yml"
              if vim.fn.filereadable(project_rubocop_config) == 1 then
                vim.notify("Using project's rubocop config", vim.log.levels.Info)
                table.insert(config.cmd, "--config")
                table.insert(config.cmd, project_rubocop_config)
              else
                vim.notify("Using rubocop config from .config/rubocop/.rubocop.yml", vim.log.levels.Info)
                table.insert(config.cmd, "--config")
                table.insert(config.cmd, vim.fn.expand("~/.config/rubocop/.rubocop.yml"))
              end
            end
          end,
        },
        terraformls = {},
        -- Another forms of spell checking and it claims can do grammer, but is pretty noisy
        -- harper_ls = {},
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
        terraform = { "terraform_validate" },
        tf = { "terraform_validate" },
      },
      linters = {
        sqlfluff = {
          args = {
            "lint",
            "--format=json",
            "--dialect=postgres",
          },
        },
      },
    },
  },
}
