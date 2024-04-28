-- return {
--   {
--     "tpope/vim-fugitive",
--     keys = function()
--       return {
--         {
--           "<leader>gv",
--           "<cmd>Gvdiffsplit!<cr>",
--           desc = "[G]it [V]diffsplit, for three way merge conflict",
--         },
--       }
--     end,
--   },
-- }
-- local function toggle_diff()
--     if vim.wo.diff then
--         vim.cmd('windo diffoff')
--     else
--         vim.cmd('Gvdiffsplit!')
--     end
-- end
-- -- Function to setup key mappings for handling diffs
-- local function setup_diff_keymaps()
--     vim.api.nvim_set_keymap('n', '<leader>dl', ':diffget //2<CR>', { noremap = true, silent = true })
--     vim.api.nvim_set_keymap('n', '<leader>dr', ':diffget //3<CR>', { noremap = true, silent = true })
--     vim.api.nvim_set_keymap('n', '<leader>dt', '<cmd>lua toggle_diff()<CR>', { noremap = true, silent = true })
-- end
-- Plugin configuration for vim-fugitive with key mappings
return {
  {
    "tpope/vim-fugitive",
    keys = function()
      -- setup_diff_keymaps()
      return {
        {
          "<leader>gv",
          "<cmd>Gvdiffsplit!<CR>",
          desc = "[G]it [V]diffsplit, for three way merge conflict",
        },
      }
    end,
  },
}
