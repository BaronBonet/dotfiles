-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Run resize methods when window size is changes
vim.api.nvim_create_augroup("_general", { clear = true })

vim.api.nvim_create_autocmd("VimResized", {
  group = "_general",
  pattern = "*",
  callback = function()
    local current_tab = vim.fn.tabpagenr()

    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Ruby --
-- Stolen from: https://github.com/prdanelli/dotfiles/blob/main/neovim-lazy/lua/config/autocmds.lua
-- vim.api.nvim_create_augroup("_ruby", { clear = true })
