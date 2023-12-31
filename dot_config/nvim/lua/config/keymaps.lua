-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim.keymap("n", "<leader>p", '"_dp')
vim.api.nvim_set_keymap("n", "<leader>p", '"_dp', { noremap = true, silent = true })
