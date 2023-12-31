return {
  {
    "christoomey/vim-tmux-navigator",
    enabled = true,
    event = "VeryLazy",

    -- allow you to switch tmux panes from within lazynvim
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Tmux Navigate Left" },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Tmux Navigate Down" },
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Tmux Navigate Up" },
      { "<c-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Tmux Navigate Right" },
    },
  },
}
