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
  -- {
  --   "folke/snacks.nvim",
  --   ---@type snacks.Config
  --   opts = {
  --     explorer = {
  --       -- your explorer configuration comes here
  --       -- or leave it empty to use the default settings
  --       -- refer to the configuration section below
  --     },
  --     picker = {
  --       sources = {
  --         explorer = {
  --           -- your explorer picker configuration comes here
  --           -- or leave it empty to use the default settings
  --         },
  --       },
  --     },
  --   },
  --   keys = function()
  --     return {
  --       {
  --         "<leader>e",
  --         function()
  --           require("snacks").explorer()
  --         end,
  --         desc = "Snacks Explorer",
  --       },
  --       {
  --         "<leader>f",
  --         function()
  --           require("snacks").picker()
  --         end,
  --         desc = "Snacks Picker",
  --       },
  --     }
  --   end,
  -- },
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
}
