return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        -- TODO: this seems to slow down nvim
        go = { "golangcilint" },
        markdown = { "markdownlint-cli2" }, -- configs live in ~/.markdownlintrc
        proto = { "buf_lint" },
        sql = { "sqlfluff" },
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
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        -- Using the Go toolchain version of goimports
        ["go"] = { "goimports", "gofumpt", "golines" },
        -- ["go"] = { "goimports", "gofumpt" },
        ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
        ["sql"] = { "sqlfluff" },
        ["proto"] = { "buf" },
      },
      formatters = {
        -- ["goimports"] = {
        --   command = "go",
        --   args = { "tool", "goimports" },
        -- },
        ["golines"] = {
          args = { "--base-formatter=gofmt", "--ignore-generated", "--no-reformat-tags", "--chain-split-dots", "-m" },
        },
        ["markdown-toc"] = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find("<!%-%- toc %-%->") then
                return true
              end
            end
          end,
        },
        ["markdownlint-cli2"] = {
          condition = function(_, ctx)
            local diag = vim.tbl_filter(function(d)
              return d.source == "markdownlint"
            end, vim.diagnostic.get(ctx.buf))
            return #diag > 0
          end,
        },
      },
    },
  },
}
