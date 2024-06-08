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
        -- both for ruby
        "sorbet",
        "rubocop",
        "erb-lint",
      })
    end,
  },
  {
    -- Responsible for custom configuration for the language server if needed
    "neovim/nvim-lspconfig",
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
      },
    },
  },
  -- Responsible for automatic formatting, if you press <leader>f this is run
  -- Check formatters here: https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["python"] = { "black", "isort" },
        ["go"] = { "goimports", "gofmt", "golines" },
        ["lua"] = { "stylua" },
        ["sql"] = { "sqlfluff" },
        -- ["*"] = { "codespell" }, -- TODO: This will autoformat spelling, which can be annoying for things like [S]ymbols, since it changes it to [S]symbols
        -- TODO: figure out how to get shellharden to work
        ["ruby"] = { "rubyfmt", "rubocop" },
      },
      formatters = {
        golines = { prepend_args = { "--no-reformat-tags", "-m", "120", "--base-formatter=gofmt" } },
      },
    },
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
        eruby = { "rubocop" },
        ruby = { "rubocop" },
      },
    },
  },
}
