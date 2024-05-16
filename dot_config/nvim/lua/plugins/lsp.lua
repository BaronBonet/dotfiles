-- For ruby make sure it's installed correctly, follow this for help:
-- https://github.com/rvm/rvm/issues/5285#issuecomment-1623030117
-- https://stackoverflow.com/a/38194139/9236687
--
-- Perhaps solargraph i snot wahat we want?
-- https://github.com/neovim/nvim-lspconfig/issues/387
--
-- https://www.reddit.com/r/ruby/comments/12ube5b/which_lsp_do_you_use_in_neovim/
return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "shellcheck",
        "shellharden",
        -- both for ruby
        "solargraph",
        "sorbet",
      })
    end,
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
        -- For ruby
        sorbet = {},
        solargraph = {
          root_dir = function(fname)
            return require("lspconfig").util.root_pattern("Gemfile", ".git")(fname) or vim.fn.getcwd()
          end,
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
