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
      autoformat = false, -- format with <leader>cf
      servers = {
        lua_ls = {
          Lua = {
            -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            diagnostics = { globals = { "vim" }, disable = { "missing-fields" } },
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
        ["*"] = { "codespell" },
      },
    },
  },
}
