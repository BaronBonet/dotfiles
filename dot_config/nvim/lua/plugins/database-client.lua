local sql_ft = { "sql", "mysql", "plsql" }

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "sql" })
      end
    end,
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.right, {
        title = "Database",
        ft = "dbui",
        pinned = true,
        open = function()
          vim.cmd("DBUI")
        end,
      })

      table.insert(opts.bottom, {
        title = "DB Query Result",
        ft = "dbout",
      })
    end,
  },
  {
    "tpope/vim-dadbod",
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      { "kristijanhusak/vim-dadbod-completion", ft = sql_ft },
      { "jsborjesson/vim-uppercase-sql", ft = sql_ft },
    },
    keys = function()
      return {
        {
          "<leader>l",
          function()
            -- Loads an env file in the current directory and sets the environment variables
            -- Workflow should be add the DB url to the env file then open DBUI to assess the databases
            -- Used when db credentials are stored in the .env file
            -- For example:
            -- DB_UI_DEV=postgres://uname:password@localhost:5432/db_name
            -- The name of the environment variable should be in the format: DB_UI_<name of connection in UI>
            local cwd = vim.fn.getcwd()
            local env_file = cwd .. "/.env"

            if vim.fn.filereadable(env_file) == 1 then
              local lines = vim.fn.readfile(env_file)

              for _, line in ipairs(lines) do
                if not line:find("=") then
                  goto continue
                  ::continue::
                end
                local parts = vim.split(line, "=")
                if #parts == 2 then
                  vim.fn.setenv(parts[1], parts[2])
                end
              end
            end
            vim.cmd("DBUIToggle")
          end,
          desc = "[L]aunch Database Client",
        },
      }
    end,
    init = function()
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_execute_on_save = false
      vim.g.db_ui_use_nvim_notify = true

      vim.api.nvim_create_autocmd("FileType", {
        pattern = sql_ft,
        callback = function()
          ---@diagnostic disable-next-line: missing-fields
          local cmp = require("cmp")
          local global_sources = cmp.get_config().sources
          local buffer_sources = {}

          -- add globally defined sources (see separate nvim-cmp config)
          -- this makes e.g. luasnip snippets available since luasnip is configured globally
          if global_sources then
            for _, source in ipairs(global_sources) do
              table.insert(buffer_sources, { name = source.name })
            end
          end

          -- add vim-dadbod-completion source
          table.insert(buffer_sources, { name = "vim-dadbod-completion" })

          -- update sources for the current buffer
          cmp.setup.buffer({ sources = buffer_sources })
        end,
      })
    end,
  },
}
