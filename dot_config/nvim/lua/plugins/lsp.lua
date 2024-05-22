return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "shellcheck",
        "shellharden",
        -- both for ruby
        -- "solargraph", -- Seems to be slow
        -- "sorbet",
        "rubocop",
      })
    end,
  },
  {
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
        -- For ruby
        -- sorbet = {},
        -- solargraph = {
        --   root_dir = function(fname)
        --     return require("lspconfig").util.root_pattern("Gemfile", ".git")(fname) or vim.fn.getcwd()
        --   end,
        -- },
        -- rubocop = {
        --   filetypes = { "eruby", "ruby" },
        -- },
      },
    },
  },
  -- formatting
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["python"] = { "black", "isort" },
        ["go"] = { "goimports", "gofmt", "golines" },
        ["lua"] = { "stylua" },
        ["sql"] = { "sqlfluff" },
        ["*"] = { "codespell" },
      },
      formatters = {
        golines = { prepend_args = { "--no-reformat-tags", "-m", "120", "--base-formatter=gofmt" } },
      },
    },
  },
  -- linting
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        go = { "golangcilint" },
        markdown = { "markdownlint" }, -- configs live in ~/.markdownlintrc
        proto = { "buf_lint" },
        dockerfile = { "hadolint" },
        -- eruby = { "rubocop" },
        -- ruby = { "rubocop" },
      },
    },
  },
}
