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
          color = colors.bg_highlight,
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
