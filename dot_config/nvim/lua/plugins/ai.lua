local config_avante = function()
  local api_key_name = "ANTHROPIC_API_KEY"
  local function set_api_key()
    local api_key_cmd = "op item get CLAUDE_API_KEY --fields label=password --reveal"
    local api_key = vim.fn.system(api_key_cmd):gsub("\n", "")
    vim.fn.setenv(api_key_name, api_key)
  end

  if vim.fn.getenv(api_key_name) == vim.NIL then
    set_api_key()
    require("avante").setup()
  end
end
return {
  {
    "zbirenbaum/copilot.lua",
    lazy = true,
    keys = function()
      local copilot_enabled = vim.fn.system("Copilot status"):find("Copilot is enabled") ~= nil
      return {
        {
          "<leader>ac",
          function()
            if copilot_enabled then
              vim.cmd("Copilot disable")
              print("Copilot disabled")
              copilot_enabled = false
            else
              vim.cmd("Copilot enable")
              print("Copilot enabled")
              copilot_enabled = true
            end
          end,
          desc = "[A]uto toggle [c]opilot",
        },
      }
    end,
  },
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
    build = "make",
    keys = { -- See https://github.com/yetone/avante.nvim/wiki#keymaps for more info
      {
        "<leader>aa",
        function()
          config_avante()
          require("avante.api").ask()
        end,
        desc = "avante: ask",
        mode = { "n", "v" },
      },
      {
        "<leader>ae",
        function()
          config_avante()
          require("avante.api").edit()
        end,
        desc = "avante: edit",
        mode = { "n", "v" },
      },
    },
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua", -- for providers='copilot'
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
