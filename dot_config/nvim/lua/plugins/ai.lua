return {
  -- {
  --   "zbirenbaum/copilot.lua",
  --   lazy = true,
  --   keys = function()
  --     local copilot_enabled = vim.fn.system("Copilot status"):find("Copilot is enabled") ~= nil
  --     return {
  --       {
  --         "<leader>ac",
  --         function()
  --           if copilot_enabled then
  --             vim.cmd("Copilot disable")
  --             print("Copilot disabled")
  --             copilot_enabled = false
  --           else
  --             vim.cmd("Copilot enable")
  --             print("Copilot enabled")
  --             copilot_enabled = true
  --           end
  --         end,
  --         desc = "[A]uto toggle [c]opilot",
  --       },
  --     }
  --   end,
  -- },
  {
    "jackMort/ChatGPT.nvim",
    lazy = true,
    opts = {
      -- Get the API key from one password vault
      api_key_cmd = "op item get OpenAI_API_KEY --fields label=password --reveal",
      openai_params = {
        model = "gpt-4o",
        frequency_penalty = 0,
        presence_penalty = 0,
        max_tokens = 4000,
        temperature = 0,
        top_p = 1,
        n = 1,
      },
      openai_edit_params = {
        model = "gpt-4o",
        frequency_penalty = 0,
        presence_penalty = 0,
        temperature = 0,
        top_p = 1,
        n = 1,
      },
      popup_window = {
        border = {
          highlight = "FloatBorder",
          style = "rounded",
          text = {
            top = " Eric's Little Helper ",
          },
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = function()
      return {
        { "<leader>ic", "<cmd>ChatGPT<CR>", desc = "A[i] ChatGPT" },
        { "<leader>ie", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction", mode = { "n", "v" } },
        { "<leader>is", "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize", mode = { "n", "v" } },
        { "<leader>ix", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code", mode = { "n", "v" } },
      }
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    opts = {
      -- add any opts here
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
