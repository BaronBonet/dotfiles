return {
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle", -- optional for lazy loading on command
    event = { "InsertLeave", "TextChanged" },
    opts = {
      -- execution_message = {
      --   enabled = false,
      -- },
      trigger_events = { defer_save = { "InsertLeave" } },
    },
    keys = function()
      return {
        {
          "<leader>as",
          function()
            require("auto-save").toggle()
          end,
          desc = "[A]uto [S]ave",
        },
      }
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = function()
      local keys = {
        {
          "<leader>H",
          function()
            require("harpoon"):list():add()
          end,
          desc = "[H]arpoon File",
        },
        {
          "<leader>h",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "[h]arpoon Quick Menu",
        },
      }

      for i = 6, 9 do
        table.insert(keys, {
          "<leader>" .. i,
          function()
            require("harpoon"):list():select(i - 5)
          end,
          desc = "Harpoon to File " .. i - 5,
        })
      end
      return keys
    end,
  },
  {
    "folke/trouble.nvim",
    keys = function()
      return {
        { "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>", desc = "[T]oggle [T]rouble" },
        {
          "<leader>tT",
          "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
          desc = "[T]oggle [T]rouble current buffer",
        },
        { "<leader>ts", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "[T]oggle [S]ymbols Trouble" },
        {
          "<leader>tS",
          "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
          desc = "[T]rouble L[S]P references/definitions/...",
        },
        { "<leader>tl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
        { "<leader>tq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
        { "<leader>to", "<cmd>TodoTrouble<cr>", desc = "[T]o d[o]" },
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "LazyFile",
    config = true,
    keys = function()
      return {}
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    -- Includes ability to use ctrl+h to toggle hidden files when doing some searching
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
    },
    keys = function()
      local builtin = require("telescope.builtin")
      local action_state = require("telescope.actions.state")
      local actions = require("telescope.actions")
      return {
        {
          "<leader>so",
          function()
            builtin.oldfiles({ cwd_only = true })
          end,
          desc = "[S]earch [O]ld files in cwd",
        },
        {
          "<leader>sO",
          function()
            builtin.oldfiles()
          end,
          desc = "[S]earch [O]ld files in all directories",
        },
        {
          "<leader>sw",
          function()
            require("telescope.builtin").grep_string()
          end,
          desc = "[S]earch current [W]ord",
        },
        {
          "<leader>sf",
          function()
            local function find_files_optionally_show_hidden(opts, no_ignore)
              opts = opts or {}
              no_ignore = vim.F.if_nil(no_ignore, false)
              opts.attach_mappings = function(_, map)
                map({ "n", "i" }, "<C-h>", function(prompt_bufnr)
                  local prompt = require("telescope.actions.state").get_current_line()
                  require("telescope.actions").close(prompt_bufnr)
                  no_ignore = not no_ignore
                  find_files_optionally_show_hidden({ default_text = prompt }, no_ignore)
                end)
                return true
              end

              if no_ignore then
                opts.no_ignore = true
                opts.hidden = true
                opts.prompt_title = "Find Files <ALL>"
                builtin.find_files(opts)
              else
                opts.prompt_title = "Find Files"
                builtin.find_files(opts)
              end
            end
            find_files_optionally_show_hidden()
          end,
          desc = "[S]earch all [F]iles in your current working directory, except for git",
        },
        {
          "<leader>sg",
          function()
            local function find_git_root()
              -- Use the current buffer's path as the starting point for the git search
              local current_file = vim.api.nvim_buf_get_name(0)
              local current_dir
              local cwd = vim.fn.getcwd()
              -- If the buffer is not associated with a file, return nil
              if current_file == "" then
                current_dir = cwd
              else
                -- Extract the directory from the current file's path
                current_dir = vim.fn.fnamemodify(current_file, ":h")
              end

              -- Find the Git root directory from the current file's path
              local git_root =
                vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
              if vim.v.shell_error ~= 0 then
                print("Not a git repository. Searching on current working directory")
                return cwd
              end
              return git_root
            end

            local git_root = find_git_root()

            local function find_git_root_optionally_show_hidden(default_text, no_ignore)
              local opts = {}
              opts.search_dirs = { git_root }
              opts.attach_mappings = function(_, map)
                map({ "n", "i" }, "<C-h>", function(prompt_bufnr)
                  local prompt = require("telescope.actions.state").get_current_line()
                  require("telescope.actions").close(prompt_bufnr)
                  find_git_root_optionally_show_hidden(prompt, not no_ignore)
                end)
                return true
              end

              if no_ignore then
                opts.prompt_title = "Grep (git root) <ALL>"
                opts.default_text = default_text
                opts.additional_args = function()
                  return { "--hidden", "--no-ignore" }
                end
                builtin.live_grep(opts)
              else
                opts.prompt_title = "Grep (git root)"
                opts.default_text = default_text
                builtin.live_grep(opts)
              end
            end
            find_git_root_optionally_show_hidden()
          end,
          desc = "[S]earch by [G]rep on Git Root",
        },
        { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
        { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
        { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "[S]earch [C]ommand History" },
        { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "[S]earch available [C]ommands" },
        { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume last telescope session" },
        {
          "sp",
          function()
            builtin.resume()
          end,
          desc = "[S]earch the [P]revious telescope picker",
        },
        {
          "<leader>sF",
          function()
            builtin.treesitter()
          end,
          desc = "[S]earch available [F]unctions",
        },
        { "<leader>sG", "<cmd>Telescope git_commits<CR>", desc = "[S]earch [G]it Commits" },
        {
          "<leader>ss",
          "<cmd>Telescope lsp_document_symbols<CR>",
          desc = "[S]earch [S]ymbols in the current document",
        },
        {
          "<leader>sh",
          function()
            builtin.git_bcommits({
              attach_mappings = function(_, map)
                map("i", "<CR>", function(prompt_bufnr)
                  local selection = action_state.get_selected_entry()
                  actions.close(prompt_bufnr)
                  local commit_hash = selection.value
                  vim.cmd("Gvdiffsplit " .. commit_hash)
                end)
                map("n", "<CR>", function(prompt_bufnr)
                  local selection = action_state.get_selected_entry()
                  actions.close(prompt_bufnr)
                  local commit_hash = selection.value
                  vim.cmd("Gvdiffsplit " .. commit_hash)
                end)
                return true
              end,
            })
          end,
          desc = "[S]earch [h]istory of commits for THIS file",
        },
      }
    end,
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      require("rainbow-delimiters.setup").setup({
        highlight = {
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterRed",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    keys = function()
      return {
        {
          "<leader>gs",
          function()
            require("gitsigns").stage_hunk()
          end,
          desc = "Stage hunk",
        },
        {
          "<leader>gu",
          function()
            require("gitsigns").undo_stage_hunk()
          end,
          desc = "Undo stage hunk",
        },
        {
          "<leader>gS",
          function()
            require("gitsigns").stage_buffer()
          end,
          desc = "git Stage entire buffer",
        },
        {
          "<leader>gd",
          function()
            require("gitsigns").diffthis()
          end,
          desc = "git diff against index",
        },
        {
          "<leader>gD",
          function()
            require("gitsigns").diffthis("~")
          end,
          desc = "git diff against last commit",
        },
        {
          "<leader>gb",
          function()
            require("gitsigns").blame_line({ full = false })
          end,
          desc = "git blame line",
        },
        {
          "<leader>gm",
          function()
            require("gitsigns").diffthis("main")
          end,
          desc = "git blame full",
        },
      }
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        position = "float",
      },
      filesystem = {
        filtered_items = {
          visible = false,
          hide_gitignored = true,
          hide_dotfiles = false,
          hide_by_pattern = { "*/.git" },
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
        },
      },
    },
    keys = function()
      return {
        {
          "<leader>e",
          function()
            require("neo-tree.command").execute({
              toggle = true,
              reveal = true, -- auto expand current file
              dir = require("lazyvim.util").root(),
            })
          end,
          desc = "Explorer NeoTree (project root dir)",
        },
        {
          "<leader>E",
          function()
            require("neo-tree.command").execute({ toggle = true, reveal = true, dir = vim.loop.cwd() })
          end,
          desc = "Explorer NeoTree (cwd, where you opened nvim)",
        },
      }
    end,
  },
  {
    -- https://github.com/kylechui/nvim-surround?tab=readme-ov-file#rocket-usage
    -- The three "core" operations of add/delete/change can be done
    -- with the keymaps ys{motion}{char}, ds{char}, and cs{target}{replacement}, respectively.
    --     Old text                    Command         New text
    -- --------------------------------------------------------------------------------
    --     surr*ound_words             ysiw)           (surround_words)
    --     *make strings               ys$"            "make strings"
    --     [delete ar*ound me!]        ds]             delete around me!
    --     remove <b>HTML t*ags</b>    dst             remove HTML tags
    --     'change quot*es'            cs'"            "change quotes"
    --     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
    --     delete(functi*on calls)     dsf             function calls
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      {
        "<leader>rr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Sea[r]ch and [R]eplace",
      },
      {
        "<leader>rw",
        function()
          require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>"), flags = vim.fn.expand("%") } })
        end,
        desc = "[R]eplace current [w]ord in file",
      },
    },
  },
  -- Color hash colors
  -- there might be a conflict with mini.hipatters
  -- https://github.com/norcalli/nvim-colorizer.lua/issues/102
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
    event = "BufEnter",
    opts = { "*" },
  },
}
