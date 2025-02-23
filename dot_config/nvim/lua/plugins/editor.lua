return {
  {
    "ibhagwan/fzf-lua",
    opts = {
      winopts = {
        border = "none",
        preview = { flip_columns = 200, border = "border-top" },
      },
    },
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
    "lewis6991/gitsigns.nvim",
    keys = function()
      return {
        {
          "<leader>gb",
          function()
            require("gitsigns").blame_line({ full = false })
          end,
          desc = "git blame line",
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
          "<leader>gm",
          function()
            require("gitsigns").diffthis("main")
          end,
          desc = "git blame full",
        },
      }
    end,
  },
  -- {
  --   "okuuva/auto-save.nvim",
  --   cmd = "ASToggle", -- optional for lazy loading on command
  --   event = { "InsertLeave", "TextChanged" },
  --   opts = {
  --     -- execution_message = {
  --     --   enabled = false,
  --     -- },
  --     trigger_events = { defer_save = { "InsertLeave" } },
  --   },
  --   keys = function()
  --     return {
  --       {
  --         "<leader>qz",
  --         function()
  --           require("auto-save").toggle()
  --         end,
  --         desc = "Toggle auto save",
  --       },
  --     }
  --   end,
  -- },
}
