return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "night",
      on_highlights = function(hl, c)
        hl.Visual = {
          bg = "#806340", -- Set the background color for the visual mode selection
        }
        -- -- TODO: remove if no longer using telescope Borderless telescope
        -- local prompt = "#2d3149"
        -- hl.TelescopeNormal = {
        --   bg = c.bg_dark,
        --   fg = c.fg_dark,
        -- }
        -- hl.TelescopeBorder = {
        --   bg = c.bg_dark,
        --   fg = c.bg_dark,
        -- }
        -- hl.TelescopePromptNormal = {
        --   bg = prompt,
        -- }
        -- hl.TelescopePromptBorder = {
        --   bg = prompt,
        --   fg = prompt,
        -- }
        -- hl.TelescopePromptTitle = {
        --   bg = prompt,
        --   fg = prompt,
        -- }
        -- hl.TelescopePreviewTitle = {
        --   bg = c.bg_dark,
        --   fg = c.bg_dark,
        -- }
        -- hl.TelescopeResultsTitle = {
        --   bg = c.bg_dark,
        --   fg = c.bg_dark,
        -- }
      end,
    },
  },
  -- Color hash colors
  -- there might be a conflict with mini.hipatters
  -- https://github.com/norcalli/nvim-colorizer.lua/issues/102
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
    event = "BufEnter",
    opts = { "*" },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      require("rainbow-delimiters.setup").setup({
        highlight = {
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterRed",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      })
    end,
  },
}
