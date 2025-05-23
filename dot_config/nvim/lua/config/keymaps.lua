-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(mode, l, r, opts)
  opts = opts or {}
  vim.keymap.set(mode, l, r, opts)
end

map("n", "<leader>qq", "<cmd>q<cr>", { noremap = true, desc = "[Q]uit" })
map("n", "<leader>qa", "<cmd>qa<cr>", { noremap = true, desc = "[Q]uit [A]ll" })

-- TODO: how is this working when leader w now brings up the window opts?
map({ "n", "v" }, "<leader>w", "<cmd>w<CR>", { noremap = true, silent = true, desc = "[W]rite" })
map("n", "<leader>W", "<cmd>wa<CR>", { noremap = true, silent = true, desc = "[W]rite All Buffers" })

map("v", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Copy to system clipboard" })

map("n", "<leader>rn", vim.lsp.buf.rename, { noremap = true, desc = "[R]e[n]ame" })

-- Select all text in the buffer
map("n", "<leader>v", "ggVG", { noremap = true, silent = true, desc = "[V]isually Select All" })

-- Vertical split with 'leader' + '2'
map("n", "<leader>2", ":vsplit<CR>", { noremap = true, silent = true, desc = "Vertical split" })
-- Return to a single window with 'leader' + '1'
map("n", "<leader>1", ":only<CR>", { noremap = true, silent = true, desc = "Remove Vertical split" })

-- Removing default keymaps i don't use
-- https://www.lazyvim.org/configuration/general#keymaps
local function delKeyMap(keymaps)
  for _, keymap in ipairs(keymaps) do
    local success, err = pcall(function()
      vim.keymap.del("n", keymap)
    end)
    if not success then
      print("Failed to delete keymap: " .. keymap .. " - " .. err)
    end
  end
end

local normal_keymaps_to_del = {
  "<C-s>",
  "aa", -- don't use the copilot chat since i use avante
}
delKeyMap(normal_keymaps_to_del)

-- Remap incriment to ctrl-s
map("n", "<C-s>", "<C-a>", { noremap = true, silent = true, desc = "Increment" })
