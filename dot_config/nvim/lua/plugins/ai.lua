return {
  {
    "jackMort/ChatGPT.nvim",
    lazy = true,
    opts = {
      -- Get the API key from one password vault
      api_key_cmd = "op item get OpenAI_API_KEY --fields label=password --reveal",
      openai_params = {
        model = "gpt-5",
        -- max_completion_tokens = 4000,
        -- frequency_penalty = 0,
        -- presence_penalty = 0,
        -- max_tokens = 4000,
        -- temperature = 0,
        -- top_p = 1,
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
      }
    end,
    -- workaround to get gpt5 to work
    -- https://github.com/jackMort/ChatGPT.nvim/issues/473#issuecomment-2831549516
    config = function(_, opts)
      require("chatgpt").setup(opts)
      require("chatgpt.config").options.openai_params.max_tokens = nil
      require("chatgpt.config").options.openai_params.temperature = nil
    end,
  },
}
