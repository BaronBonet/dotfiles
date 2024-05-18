-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.o.clipboard = "" -- Don't use system clipboard

-- errors are underlined
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- cursor should blink when changing modes
vim.opt.guicursor = {
  "n-v-c:block-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100",
  "i-ci:ver25-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100",
  "r:hor50-Cursor/lCursor-blinkwait100-blinkon100-blinkoff100",
}

-- Customize current line highlight color
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2a2a2a" })

-- Customize visual mode selection color
vim.api.nvim_set_hl(0, "Visual", { bg = "#FF0000" })

-- spell check
vim.api.nvim_command("autocmd FileType markdown,text,tex,go,python setlocal spell")

-- When moving with ctr-<d or u> center cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- disable mouse
-- vim.opt.mouse = ""
