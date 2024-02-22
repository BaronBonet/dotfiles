-- tdoo: add a keybinding to show all breakpoints
return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "delve" })
        end,
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = "mason.nvim",
        opts = {
          -- Makes a best effort to setup the various debuggers with
          -- reasonable debug configurations
          automatic_setup = true,
          automatic_installation = true,

          handlers = {},

          ensure_installed = {
            "delve",
            "python",
          },
        },
      },
      {
        "rcarriga/nvim-dap-ui",
        -- disable default keybindings
        keys = function()
          return {}
        end,
        opts = {},
        config = function(_, opts)
          -- To enable auto completing in the terminal
          -- require("neodev").setup({
          --   library = { plugins = { "nvim-dap-ui" }, types = true },
          -- })

          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open({})
          end
          dapui.setup({
            icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
            controls = {
              enabled = true,
              icons = {
                pause = "⏸",
                play = "▶",
                step_into = "⏎",
                step_over = "⏭",
                step_out = "⏮",
                step_back = "b",
                run_last = "▶▶",
                terminate = "⏹",
                disconnect = "⏏",
              },
            },
            layouts = {
              {
                elements = {
                  {
                    id = "repl",
                    size = 0.4,
                  },
                  {
                    id = "console",
                    size = 0.35,
                  },
                  {
                    id = "scopes",
                    size = 0.25,
                  },
                },
                position = "bottom",
                size = 20,
              },
            },
          })
        end,
      },
    },
    keys = function()
      return {
        {
          "<leader>db",
          function()
            require("dap").toggle_breakpoint()
          end,
          desc = "Toggle Breakpoint",
        },
        {
          "<leader>dB",
          function()
            require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
          end,
          desc = "Set Conditional Breakpoint",
        },
        {
          "<leader>dc",
          function()
            require("dap").continue()
          end,
          desc = "Start/Continue",
        },
        {
          "<leader>ds",
          function()
            require("dapui").toggle()
          end,
          desc = "See last session result",
        },
        {
          "<leader>di",
          function()
            require("dap").step_into()
          end,
          desc = "Step Into",
        },
        {
          "<leader>do",
          function()
            require("dap").step_over()
          end,
          desc = "Step Over",
        },
        {
          "<leader>dr",
          function()
            require("dap").restart()
          end,
          desc = "Restart",
        },
        {
          "<leader>dt",
          function()
            local filetype = vim.bo.filetype
            if filetype == "go" then
              require("dap-go").debug_test()
            else
              -- since i only use pytest don't need to use test_class
              require("dap-python").test_method()
            end
          end,
          desc = "Debug the closest test method above the cursor",
        },
        {
          "<leader>dw",
          function()
            require("dap.ui.widgets").hover()
          end,
          desc = "Widgets",
        },
        {
          "<leader>de",
          function()
            require("dap").terminate()
          end,
          desc = "End the debug session",
        },
      }
    end,
    config = function()
      -- icons and a visual line when for the debug session
      local Config = require("lazyvim.config")
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(Config.icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end
      -- You have to install debugpy in a seperate virtuaenv for this to work
      -- https://github.com/mfussenegger/nvim-dap-python?tab=readme-ov-file#debugpy
      require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
      require("dap-python").test_runner = "pytest"

      require("dap").configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch File",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          env = {
            PYTHONPATH = vim.fn.getcwd() .. ":" .. (os.getenv("PYTHONPATH") or ""),
          },
        },
      }
    end,
  },
  {
    -- TODO: This (debugger autocomplete) is working for python but not for go
    "rcarriga/cmp-dap",
    config = function()
      require("cmp").setup({
        enabled = function()
          return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
        end,
      })

      require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
          { name = "dap" },
        },
      })
    end,
  },
}
