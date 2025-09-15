local colors = require("tokyonight.colors").setup()

return {
  -- messages, cmdline and the popupmenu
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    config = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_SplitWidth = 35
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
    keys = { { "<leader>uu", ":UndotreeToggle<CR>", desc = "[U]i [U]ndoTree toggle" } },
  },
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPre",
    config = function()
      require("scrollbar").setup({
        handle = {
          color = colors.dark3,
          blend = 30, -- Integer between 0 and 100. 0 for fully opaque and 100 to full transparent.
        },
        marks = {
          Search = { color = colors.orange },
          Error = { color = colors.error },
          Warn = { color = colors.warning },
          Info = { color = colors.info },
          Hint = { color = colors.hint },
          Misc = { color = colors.purple },
        },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local LazyVim = require("lazyvim.util")
      local highlight = require("lualine.highlight")
      local icons = require("lazyvim.config").icons
      local lazy_status = require("lazy.status")

      local function lsp_client_names()
        local clients = {}
        local bufnr = vim.api.nvim_get_current_buf()
        if vim.lsp.get_clients then
          clients = vim.lsp.get_clients({ bufnr = bufnr }) or {}
        else
          return "No Active LSP"
        end

        local names = {}
        for _, client in ipairs(clients) do
          local name = client.name
          if name and name ~= "" and not name:lower():find("copilot", 1, true) then
            table.insert(names, name)
          end
        end

        if #names == 0 then
          return "No Active LSP"
        end

        table.sort(names)
        return table.concat(names, ", ")
      end

      local function diff_source()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
          }
        end
      end

      local function mode_colors()
        local suffix = highlight.get_mode_suffix()
        local hl = highlight.get_lualine_hl("lualine_a" .. suffix)
        if hl then
          return { fg = hl.fg, bg = hl.bg }
        end
      end

      opts.sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = diff_source,
          },
        },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { LazyVim.lualine.pretty_path() },
        },
        lualine_x = {
          {
            lsp_client_names,
            icon = " ",
            color = { fg = "#2ac3de", gui = "bold" },
          },
          {
            function()
              return "  " .. require("dap").status()
            end,
            cond = function()
              return package.loaded["dap"] and require("dap").status() ~= ""
            end,
            color = { fg = Snacks.util.color("Debug") },
          },
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = Snacks.util.color("Special") },
          },
        },
        lualine_y = {
          {
            "location",
            padding = { left = 1, right = 0 },
            color = mode_colors,
          },
        },
        lualine_z = {},
      }

      return opts
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      preset = "helix",
      spec = {
        {
          { "<leader>a", group = "[A]i" },
        },
      },
    },
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        width = 180,
      },
      plugins = {
        gitsigns = true,
        tmux = true,
        alacritty = {
          enabled = true,
        },
      },
    },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "[Z]en Mode" } },
  },
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        enabled = false, -- This disables the explorer
      },
      -- Other snacks options...
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      local api = require("pymple.api")
      local config = require("pymple.config")

      local function on_move(args)
        print(args.source, args.destination)
        print("api")
        print(api)
        api.update_imports(args.source, args.destination, config.user_config.update_imports)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })

      opts.window = opts.window or {}
      opts.filesystem = opts.filesystem or {}
      opts.window.position = "float"
      opts.filesystem.filtered_items = {
        visible = false,
        hide_gitignored = true,
        hide_dotfiles = false,
        hide_by_pattern = { "*/.git" },
      }
      opts.filesystem.follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      }
    end,
    keys = {
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
    },
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {
      modes = {
        symbols = { -- Configure symbols mode
          win = {
            type = "split", -- split window
            relative = "win", -- relative to current window
            position = "right", -- right side
            size = 0.3, -- 30% of the window
          },
          focus = true,
        },
      },
    },
  },
}
