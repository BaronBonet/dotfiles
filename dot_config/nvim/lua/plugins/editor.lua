return {
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
        {
          "<leader>sf",
          function()
            local builtin = require("telescope.builtin")
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
            local builtin = require("telescope.builtin")
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
        -- { "<leader>sr", "<cmd>Telescope registers<cr>", desc = "Search Registers" },
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
        { "<leader>sG", "<cmd>Telescope git_commits<CR>", desc = "[S]earch [G]it Commits" },
        {
          "<leader><space>",
          require("lazyvim.util").telescope("files"),
          desc = "Find Files (root dir) respect_gitignore",
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
        {
          "-",
          function()
            require("neo-tree.command").execute({ toggle = true, position = "current" })
          end,
          desc = "Toggle Neotree (reveal in current position)",
        },
      }
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    keys = {
      {
        "<leader>rr",
        function()
          require("spectre").open()
        end,
        desc = "[R]eplace in Files (Spectre)",
      },
      {
        "<leader>rw",
        function()
          require("spectre").open_visual({ select_word = true })
        end,
        desc = "[R]eplace current [Word] in files (Spectre)",
      },
      {
        "<leader>rf",
        function()
          require("spectre").open_file_search({ select_word = true })
        end,
        desc = "[R]eplace current word in current [F]ile (Spectre)",
      },
      {
        "<leader>rt",
        function()
          require("spectre").toggle()
        end,
        desc = "[R]ename [T]oggle (Spectre)",
      },
    },
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
