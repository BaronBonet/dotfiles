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

local function has_conflicts()
  local current_file = vim.fn.expand("%:p")
  local handle = io.popen("git diff --name-only --diff-filter=U --relative")
  local result = handle:read("*a")
  handle:close()
  for file in result:gmatch("[^\r\n]+") do
    if vim.fn.fnamemodify(file, ":p") == current_file then
      return true
    end
  end
  return false
end
return {
  {
    "tpope/vim-fugitive",
    lazy = false, -- https://github.com/tpope/vim-fugitive/issues/2236#issuecomment-1833945311
    keys = function()
      return {
        {
          "<leader>gv",
          function()
            if has_conflicts() then
              vim.cmd("Gvdiffsplit!")
            else
              print("No conflicts to resolve in this buffer.")
            end
          end,
          desc = "[G]it [V]diffsplit, for three way merge conflict",
        },
        {
          "<leader>grh",
          "<cmd>diffget //2<CR>",
          desc = "[G]it [R]esolve select [H]ead, get from HEAD, the left pane",
        },
        {
          "<leader>grl",
          "<cmd>diffget //3<CR>",
          desc = "[G]it [R]esolve [L]ocal, get from local, the right pane",
        },
        {
          "<leader>grn",
          function()
            if not has_conflicts() then
              vim.cmd("wincmd o") -- Clear the workspace

              local current_file = vim.fn.expand("%:p")
              os.execute("git add " .. current_file)

              vim.cmd("bn") -- Move to the next buffer
            else
              print("There are still merge conflicts to resolve")
            end
          end,
          desc = "[G]it [R]esolve [N]ext, clear workspace and move to next buffer if conflicts are resolved",
        },
      }
    end,
  },
  {
    "sindrets/diffview.nvim",
    keys = function()
      return {
        {
          "<leader>gc",
          function()
            local current_file = vim.fn.expand("%:p")
            local relative_path = vim.fn.fnamemodify(current_file, ":.")

            require("telescope.builtin").git_commits({
              git_command = { "git", "log", "--pretty=oneline", "--", relative_path },
              attach_mappings = function(_, map)
                map("i", "<CR>", function(prompt_bufnr)
                  local selection = require("telescope.actions.state").get_selected_entry()
                  require("telescope.actions").close(prompt_bufnr)
                  if selection then
                    vim.cmd("DiffviewOpen " .. selection.value:match("^(%S+)"))
                  end
                end)
                return true
              end,
            })
          end,
          desc = "[G]it [C]ommits, are listed for the file we are in, select a commit and view the diff of this current file against that commit.",
        },
      }
    end,
  },
}
