return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
      {
        "leoluz/nvim-dap-go",
        config = true,
      },
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
        lazy = true,
        -- disable default keybindings
        keys = function()
          return {}
        end,
        opts = {},
        config = function(_)
          local dap = require("dap")
          dap.set_log_level("DEBUG")
          local dapui = require("dapui")

          -- conditionally configure debugger based in filetype of code we are debugging
          local function get_elements()
            local filetype = vim.bo.filetype
            local elements = {
              {
                id = "repl",
                size = 0.4,
                mappings = {
                  n = {
                    close = { "q", "<Esc>" },
                  },
                },
              },
              {
                id = "scopes",
                size = 0.25,
              },
            }

            local languages_without_console = { "python", "go" }
            if not filetype.find(table.concat(languages_without_console, ","), filetype) then
              table.insert(elements, 2, {
                id = "console",
                size = 0.35,
              })
            else
              elements[1].size = 0.50
              elements[2].size = 0.50
            end

            return elements
          end

          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.setup({
              layouts = {
                {
                  elements = get_elements(),
                  position = "bottom",
                  size = 20,
                },
              },
            })
            dapui.open({})
          end
        end,
      },
    },
    optional = true,
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
      -- You have to install debugpy in a separate virtuaenv for this to work
      -- https://github.com/mfussenegger/nvim-dap-python?tab=readme-ov-file#debugpy
      require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
      require("dap-python").test_runner = "pytest"

      local dap = require("dap")

      -- This is a custom configuration for python with sets the PYTHONPATH to the current directory
      -- In the event a python project is set up strangly you may have to update the PYTHONPATH here to get the debugger working
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch File",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          justMyCode = false, -- Also follow importend code
          env = {
            PYTHONPATH = vim.fn.getcwd() .. ":" .. (os.getenv("PYTHONPATH") or ""),
          },
        },
      }
    end,
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
            elseif filetype == "python" then
              -- since i only use pytest don't need to use test_class
              require("dap-python").test_method()
            else
              vim.notify("No test method for filetype: " .. filetype, vim.log.levels.WARN)
            end
          end,
          desc = "Debug the closest test method above the cursor",
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
  },
}
