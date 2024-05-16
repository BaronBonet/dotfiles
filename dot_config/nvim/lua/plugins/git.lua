-- For merge conflicts give this a try
-- https://medium.com/prodopsio/solving-git-merge-conflicts-with-vim-c8a8617e3633
-- Workflow:
-- Rebase your branch on top of the target branch
-- open up vim each buffer has a conflicted file v $(git diff --name-only --diff-filter=U) alised to resolve-conflicts
-- used <leader>gv to open up a 3 way diff
-- Resolve the conflicts
-- Press <ctrl + w> + o to clear the workspace
-- use :bn to move to the next buffer (where the next conflict is), repeat the process until all conflicts are resolved
--
-- Keep in mind while in a file you can use ]c to jump to the next conflict and [c to jump to the previous conflict

return {
  {
    "tpope/vim-fugitive",
    lazy = false, -- https://github.com/tpope/vim-fugitive/issues/2236#issuecomment-1833945311
    keys = function()
      return {
        {
          "<leader>gv",
          "<cmd>Gvdiffsplit!<CR>",
          desc = "[G]it [V]diffsplit, for three way merge conflict",
        },
        {
          "<leader>gdh",
          "<cmd>diffget //2<CR>",
          desc = "[G]it [D]iff [H]unk, get from HEAD",
        },
        {
          "<leader>gdl",
          "<cmd>diffget //3<CR>",
          desc = "[G]it [D]iff [L]ocal, get from local",
        },
      }
    end,
  },
}
