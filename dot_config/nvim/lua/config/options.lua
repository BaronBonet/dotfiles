-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.guicursor = {
  "n-v-c:block-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100",
  "i-ci:ver25-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100",
  "r:hor50-Cursor/lCursor-blinkwait100-blinkon100-blinkoff100",
}

vim.g.snacks_animate = false

vim.o.clipboard = "" -- Don't use system clipboard

-- Customize current line highlight color
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2a2a2a" })

-- When moving with ctr-<d or u> center cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.g.python3_host_prog = "/Users/ebon/.asdf/shims/python3"

-- spell check
vim.api.nvim_command("autocmd FileType markdown,text,tex,go,python,proto,ruby,d2,sql setlocal spell")

-- Center cursor when searching with # or *
vim.keymap.set("n", "#", "#zz")
vim.keymap.set("n", "*", "*zz")

vim.g.lazyvim_python_ruff = "ruff"
vim.g.lazyvim_picker = "snacks"
