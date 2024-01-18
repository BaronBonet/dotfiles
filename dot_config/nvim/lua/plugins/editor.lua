-- TODO: how to make this work for all current telescope buffers
-- local my_find_files
-- my_find_files = function(opts, no_ignore)
--   opts = opts or {}
--   no_ignore = vim.F.if_nil(no_ignore, false)
--   opts.attach_mappings = function(_, map)
--     map("i", "<C-h>", function(prompt_bufnr) -- <C-h> to toggle modes
--       local prompt = require("telescope.actions.state").get_current_line()
--       require("telescope.actions").close(prompt_bufnr)
--       no_ignore = not no_ignore
--       my_find_files({ default_text = prompt }, no_ignore)
--     end)
--     return true
--   end
--
--   if no_ignore then
--     opts.no_ignore = true
--     opts.hidden = true
--     opts.prompt_title = "Find Files <ALL>"
--     require("telescope.builtin").find_files(opts)
--   else
--     opts.prompt_title = "Find Files"
--     require("telescope.builtin").find_files(opts)
--   end
-- end
return {
  -- So I don't have to remember to save a file
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave" },
    opts = {
      execution_message = {
        enabled = false,
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon"):setup({})
    end,
    keys = {
      {
        "<leader>a",
        function()
          require("harpoon"):list():append()
        end,
        desc = "[A] a file to harpoon",
      },
      {
        "<C-z>",
        function()
          local conf = require("telescope.config").values
          local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
              table.insert(file_paths, item.value)
            end

            require("telescope.pickers")
              .new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                  results = file_paths,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
              })
              :find()
          end
          local harpoon = require("harpoon")
          toggle_telescope(harpoon:list())
        end,
        desc = "Open harpoon menu",
      },
      {
        "<C-s>",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "harpoon to file 1",
      },
      {
        "<C-q>",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "harpoon to file 2",
      },
      {
        "<C-w>",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "harpoon to file 3",
      },
      {
        "<C-e>",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "harpoon to file 4",
      },
    },
  },
  {
    "folke/trouble.nvim",
  -- stylua: ignore
    keys = function()
      return {
        { "<leader>tt", function() require("trouble").toggle() end, desc = "[T]oggle [T]rouble" },
        { "<leader>tw", function() require("trouble").toggle("workspace_diagnostics") end, desc = "[T]oggle Trouble [W]orkspace" },
        { "<leader>td", function() require("trouble").toggle("document_diagnostics") end, desc = "[T]oggle Trouble [D]ocument" },
        { "<leader>tl", function() require("trouble").toggle("loclist") end, desc = "[T]oggle Trouble [L]oclist" },
        { "<leader>tq", function() require("trouble").toggle("quickfix") end, desc = "[T]oggle Trouble [Q]uickfix" },
        { "<leader>tf", function() require("trouble").toggle("file") end, desc = "[T]oggle Trouble [F]ile" },
        { "<leader>to", "<cmd>TodoTrouble<cr>", desc = "[T]o d[o]" },
        { "<leader>tT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
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
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      "nvim-telescope/telescope-file-browser.nvim",
    },
    keys = function()
      return {
        {
          "<leader>so",
          function()
            local builtin = require("telescope.builtin")
            builtin.oldfiles()
          end,
          desc = "[S]earch [O]ld files",
        },
        {
          "<leader>sw",
          function()
            require("telescope.builtin").grep_string()
          end,
          desc = "[S]earch current [W]ord",
        },
        -- FIXME: This should retrun . dotfiles e.g. .github/actions/...
        -- should this also use the git root or the project root?
        {
          "<leader>sf",
          function()
            local builtin = require("telescope.builtin")
            builtin.find_files({
              no_ignore = true,
              hidden = true,
              file_ignore_patterns = { "^.git/", "^.venv/" },
            })
          end,
          desc = "[S]earch all [F]iles in your current working directory, except for git",
        },
        -- FIXME: This should retrun . dotfiles e.g. .github/actions/...
        {
          "<leader>sG",
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
            if git_root then
              require("telescope.builtin").live_grep({
                search_dirs = { git_root },
                -- additional_args = function(opts)
                --   return { "--hidden" } -- , "--no-ignore-vcs" }
                -- end,
              })
            end
          end,
          desc = "[S]earch by [G]rep on Git Root",
        },
        { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
        { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
        { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "[S]earch [C]ommand History" },
        { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "[S]earch available [C]ommands" },
        { "<leader>sr", "<cmd>Telescope registers<cr>", desc = "Search Registers" },
        { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume last telescope session" },
        {
          "<leader>sh",
          function()
            local builtin = require("telescope.builtin")
            builtin.help_tags()
          end,
          desc = "[S]earch [H]elp available help tags",
        },
        {
          "sp",
          function()
            local builtin = require("telescope.builtin")
            builtin.resume()
          end,
          desc = "[S]earch the [P]revious telescope picker",
        },
        {
          "<leader>sF",
          function()
            local builtin = require("telescope.builtin")
            builtin.treesitter()
          end,
          desc = "[S]earch available [F]unctions",
        },
        { "<leader>sgc", "<cmd>Telescope git_commits<CR>", desc = "[S]earch [G]it [C]ommits" },
        {
          "<leader><space>",
          require("lazyvim.util").telescope("files"),
          desc = "Find Files (root dir) respect_gitignore",
        },
        -- {
        --   "<leader>e",
        --   function()
        --     local telescope = require("telescope")
        --
        --     local function telescope_buffer_dir()
        --       return vim.fn.expand("%:p:h")
        --     end
        --
        --     telescope.extensions.file_browser.file_browser({
        --       path = "%:p:h",
        --       cwd = telescope_buffer_dir(),
        --       respect_gitignore = true,
        --       hidden = false,
        --       grouped = true,
        --       previewer = true,
        --       initial_mode = "normal",
        --       layout_config = { height = 40 },
        --     })
        --   end,
        --   desc = "Open File Browser don't show gitignore",
        -- },
        -- {
        --   "<leader>E",
        --   function()
        --     local telescope = require("telescope")
        --
        --     local function telescope_buffer_dir()
        --       return vim.fn.expand("%:p:h")
        --     end
        --
        --     telescope.extensions.file_browser.file_browser({
        --       path = "%:p:h",
        --       cwd = telescope_buffer_dir(),
        --       respect_gitignore = false,
        --       hidden = true,
        --       grouped = true,
        --       previewer = true,
        --       initial_mode = "normal",
        --       layout_config = { height = 40 },
        --     })
        --   end,
        --   desc = "Open File Browser showing [E]verything",
        -- },
        -- {
        --   "<leader>ff",
        --   function()
        --     my_find_files()
        --   end,
        --   desc = "Find Files",
        -- },
      }
    end,
    config = function(_, opts)
      require("telescope").load_extension("fzf")
      -- local telescope = require("telescope")
      -- local fb_actions = require("telescope").extensions.file_browser.actions
      --
      -- local actions = require("telescope.actions")
      -- local action_state = require("telescope.actions.state")
      --
      -- -- Define a global variable to keep track of the hidden files state
      -- local telescope_hidden_files = false
      --
      -- local function toggle_hidden(prompt_bufnr)
      --   -- Toggle the global hidden files state
      --   telescope_hidden_files = not telescope_hidden_files
      --
      --   local picker = action_state.get_current_picker(prompt_bufnr)
      --   -- print fields of pickex
      --   print(vim.inspect(picker))
      --   -- Close the current picker
      --   actions.close(prompt_bufnr)
      --
      --   local current_search_word = action_state.get_current_line()
      --   local finder = picker.finder
      --
      --   local cwd = vim.fn.getcwd()
      --
      --   -- TODO: May need to make this a switch statment based on the current picker
      --   -- require("telescope.builtin").find_files({
      --   -- picker({
      --   --   hidden = telescope_hidden_files,
      --   --   no_ignore = telescope_hidden_files,
      --   --   cwd = cwd,
      --   --   default_text = current_search_word,
      --   -- })
      -- end
      --
      -- opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
      --   wrap_results = true,
      --   layout_strategy = "horizontal",
      --   layout_config = { prompt_position = "top" },
      --   sorting_strategy = "ascending",
      --   winblend = 0,
      --   prompt_prefix = "🔍",
      --   mappings = {
      --     i = {
      --       ["<C-h>"] = toggle_hidden,
      --     },
      --   },
      --   border = true,
      -- })
      -- opts.pickers = {
      --   diagnostics = {
      --     theme = "ivy",
      --     initial_mode = "normal",
      --   },
      -- }
      -- opts.extensions = {
      --   file_browser = {
      --     mappings = {
      --       ["n"] = {
      --         ["N"] = fb_actions.create,
      --         ["/"] = function()
      --           vim.cmd("startinsert")
      --         end,
      --       },
      --     },
      --   },
      -- }
      -- telescope.setup(opts)
      -- require("telescope").load_extension("file_browser")
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
          "<leader>hs",
          function()
            require("gitsigns").stage_hunk()
          end,
          desc = "Stage hunk",
        },
        {
          "<leader>hu",
          function()
            require("gitsigns").undo_stage_hunk()
          end,
          desc = "Undo stage hunk",
        },
        {
          "<leader>hS",
          function()
            require("gitsigns").stage_buffer()
          end,
          desc = "git Stage entire buffer",
        },
        {
          "<leader>hd",
          function()
            require("gitsigns").diffthis()
          end,
          desc = "git diff against index",
        },
        {
          "<leader>hD",
          function()
            require("gitsigns").diffthis("~")
          end,
          desc = "git diff against last commit",
        },
        {
          "<leader>hb",
          function()
            require("gitsigns").blame_line({ full = false })
          end,
          desc = "git blame line",
        },
        {
          "<leader>hB",
          function()
            require("gitsigns").blame_line({ full = true })
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
        },
      },
    },
    keys = function()
      return {
        {
          "<leader>e",
          function()
            require("neo-tree.command").execute({ toggle = true, dir = require("lazyvim.util").root() })
          end,
          desc = "Explorer NeoTree (root dir)",
        },
        {
          "<leader>E",
          function()
            require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
          end,
          desc = "Explorer NeoTree (cwd)",
        },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.defaults["<leader>w"] = nil
      opts.defaults["<leader>f"] = nil
      opts.defaults["<leader><tab>"] = nil
      opts.defaults["<leader>x"] = nil
      opts.defaults["<leader>u"] = { name = "[U]i" }
      opts.defaults["<leader>q"] = { name = "+[Q]uit" }
      opts.defaults["<leader>sg"] = { name = "+[G]it" }
      opts.defaults["<leader>t"] = { name = "+[T]rouble" }
      opts.defaults["<leader>r"] = { name = "+[R]ename" }
      opts.defaults["<leader>s"] = { name = "+[S]earch" }
      opts.defaults["<leader>h"] = { name = "+Git [H]unk" }
      opts.defaults["<leader>g"] = { name = "+[G]it UI" }
      return opts
    end,
  },
}
