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
    -- added this so we can get ride of the time at the bottom of the statusline
    "nvim-lualine/lualine.nvim",
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      local lualine_require = require("lualine_require")
      lualine_require.require = require

      local icons = require("lazyvim.config").icons

      vim.o.laststatus = vim.g.lualine_laststatus
      local colors = {
        [""] = { fg = Snacks.util.color("Special") },
        ["Normal"] = { fg = Snacks.util.color("Special") },
        ["Warning"] = { fg = Snacks.util.color("DiagnosticError") },
        ["InProgress"] = { fg = Snacks.util.color("DiagnosticWarn") },
      }

      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
        },
        tabline = {}, -- Tabline is for the top of the window
        sections = { -- Sections are for the bottom of the window
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
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },

          lualine_c = {
            LazyVim.lualine.root_dir(),
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
              -- Lsp server name .
              -- TODO: show multiple lsps if there are
              function()
                local msg = "No Active Lsp"
                local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
                local clients = vim.lsp.get_clients()
                if next(clients) == nil then
                  return msg
                end
                for _, client in ipairs(clients) do
                  local filetypes = client.config.filetypes
                  if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    return client.name
                  end
                end
                return msg
              end,
              icon = " ",
              color = { fg = "#2ac3de", gui = "bold" },
            },
            -- TODO: i shoudlnt have to do all of this checkout how lua line is updated with copilot
            -- https://www.lazyvim.org/extras/ai/copilot w
            {
              function()
                local icon = require("lazyvim.config").icons.kinds.Copilot
                local status = require("copilot.api").status.data
                return icon .. (status.message or "")
              end,
              cond = function()
                if not package.loaded["copilot"] then
                  return
                end
                local ok, clients = pcall(LazyVim.lsp.get_clients, { name = "copilot", bufnr = 0 })
                if not ok then
                  return false
                end
                return ok and #clients > 0
              end,
              color = function()
                if not package.loaded["copilot"] then
                  return
                end
                local status = require("copilot.api").status.data
                return colors[status.status] or colors[""]
              end,
            },
          },
          lualine_y = {
          -- This show the last command executed in normal mode
          -- {
          --   function() return require("noice").api.status.command.get() end,
          --   cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
          --   color = LazyVim.ui.fg("Statement"),
          -- },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            fg = Snacks.util.color("Constant")
              -- color = LazyVim.ui.fg("Constant"),
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
            fg = Snacks.util.color("Debug")
            -- color = LazyVim.ui.fg("Debug"),
          },
            { -- Shows which packages are not up to date
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              fg = Snacks.util.color("Special"),
              -- color = LazyVim.ui.fg("Special"),
            },
          },
          lualine_z = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
        },
      }
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
  -- Snacks explorer
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            auto_close = true,
            layout = { preset = "dropdown", preview = false, auto_hide = { "input" } },
            ignored = true,
          },
        },
      },
    },
    keys = {
      {
        "<leader>e",
        function()
          require("snacks").explorer.open()
        end,
        desc = "Toggle [E]xplorer",
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
