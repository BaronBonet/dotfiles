return {
  {
    "tpope/vim-dadbod",
    keys = function()
      return {
        {
          "<leader>l",
          function()
            vim.cmd("DBUIToggle")
          end,
          desc = "[L]aunch Database Client",
        },
      }
    end,
  },
}
