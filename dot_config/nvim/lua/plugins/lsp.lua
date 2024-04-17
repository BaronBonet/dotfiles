return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "shellcheck",
        "shellharden",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      autoformat = false, -- format with <leader>f
      servers = {
        lua_ls = {
          Lua = {
            -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            diagnostics = { globals = { "vim" }, disable = { "missing-fields" } },
          },
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
}
