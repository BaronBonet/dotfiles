-- https://www.lazyvim.org/plugins/linting#nvim-lint
return {
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
    },
  },
}
