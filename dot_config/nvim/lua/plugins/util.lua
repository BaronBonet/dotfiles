return {
  {
    "folke/persistence.nvim",
  -- stylua: ignore
  keys = function ()return {
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore [L]ast Session" }}
  end
  },
}
