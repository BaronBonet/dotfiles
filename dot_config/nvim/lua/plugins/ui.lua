local colors = require("tokyonight.colors").setup()

return {
  -- messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })
      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })

      opts.presets.lsp_doc_border = true
    end,
    keys = { { "<leader>un", "<cmd>Noice<cr>", desc = "show [N]oice notifications" } },
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
        [""] = LazyVim.ui.fg("Special"),
        ["Normal"] = LazyVim.ui.fg("Special"),
        ["Warning"] = LazyVim.ui.fg("DiagnosticError"),
        ["InProgress"] = LazyVim.ui.fg("DiagnosticWarn"),
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
            "encoding",
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
            color = LazyVim.ui.fg("Constant"),
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = LazyVim.ui.fg("Debug"),
          },
            { -- Shows which packages are not up to date
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = LazyVim.ui.fg("Special"),
            },
          },
          lualine_z = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
        },
        extensions = { "neo-tree", "lazy" },
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
      opts.defaults["<leader>q"] = { name = "+[Q]uit or reload" }
      opts.defaults["<leader>sg"] = { name = "+[G]it" }
      opts.defaults["<leader>t"] = { name = "+[T]rouble" }
      opts.defaults["<leader>r"] = { name = "+[R]ename" }
      opts.defaults["<leader>s"] = { name = "+[S]earch" }
      opts.defaults["<leader>g"] = { name = "+[G]it hunk" }
      opts.defaults["<leader>G"] = { name = "+[G]it UI" }
      opts.defaults["<leader>a"] = { name = "+[A]uto" }
      opts.defaults["<leader>b"] = { name = "[B]uffer" }
      opts.defaults["<leader>c"] = { name = "[C]ode" }
      opts.defaults["<leader>d"] = { name = "[D]ebug" }
      opts.defaults["<leader>i"] = { name = "A[I]" }
      return opts
    end,
  },
}
