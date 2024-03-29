-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(mode, l, r, opts)
  opts = opts or {}
  vim.keymap.set(mode, l, r, opts)
end

-- TODO: how to overwrite all q keymaps efficiently?
map("n", "<leader>qq", "<cmd>q<cr>", { noremap = true, desc = "[Q]uit" })
map("n", "<leader>qa", "<cmd>qa<cr>", { noremap = true, desc = "[Q]uit [A]ll" })

-- Vertical split with 'leader' + '2'
map("n", "<leader>2", ":vsplit<CR>", { noremap = true, silent = true, desc = "Vertical split" })
-- Return to a single window with 'leader' + '1'
map("n", "<leader>1", ":only<CR>", { noremap = true, silent = true, desc = "Remove Vertical split" })

map("v", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Copy to system clipboard" })

map("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, desc = "[R]e[n]ame" })

-- Select all text in the buffer
map("n", "<leader>v", "ggVG", { noremap = true, silent = true, desc = "[V]isually Select All" })

map({ "n", "v" }, "<leader>f", function()
  require("lazyvim.util").format({ force = true })
end, { desc = "[F]ormat" })

-- Removing default keymaps i don't use
-- https://www.lazyvim.org/configuration/general#keymaps
local function delKeyMap(keymaps)
  for _, keymap in ipairs(keymaps) do
    vim.keymap.del("n", keymap)
  end
end

local normal_keymaps_to_del = {
  "<leader>l",
  "<leader>L",
  "<leader>w|",
  "<leader>|",
  "<leader>-",
  "<leader>wd",
  "<leader>w-",
  "<leader>ww",
  "<leader><tab><tab>",
  "<leader><tab>[",
  "<leader><tab>]",
  "<leader><tab>d",
  "<leader><tab>f",
  "<leader><tab>l",
  "<leader>xl",
  "<leader>xq",
  "<leader>fn",
  "<leader>bb",
  "<leader>bD",
  "<leader>bd",
  "<leader>ft",
  "<leader>fT",
}

delKeyMap(normal_keymaps_to_del)
