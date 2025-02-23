-- TODO: i shouldn't need this anymore since i can use the .lazy.lua file
local sql_ft = { "sql", "mysql", "plsql" }

return {
  {
    "tpope/vim-dadbod",
    keys = function()
      return {
        {
          "<leader>l",
          function()
            -- Loads an env file in the current directory and sets the environment variables
            -- Workflow should be add the DB url to the env file then open DBUI to assess the databases
            -- Used when db credentials are stored in the .env file
            -- For example:
            -- DB_UI_DEV=postgres://uname:password@localhost:5435/db_name
            -- The name of the environment variable should be in the format: DB_UI_<name of connection in UI>
            -- local cwd = vim.fn.getcwd()
            -- local env_file = cwd .. "/.env"
            -- -- vim.notify("Starting dadbod", vim.log.levels.DEBUG)
            --
            -- if vim.fn.filereadable(env_file) == 1 then
            --   local lines = vim.fn.readfile(env_file)
            --
            --   for _, line in ipairs(lines) do
            --     local equalIndex = line:find("=")
            --     if not equalIndex then
            --       vim.notify("Invalid line: " .. line, vim.log.levels.DEBUG)
            --       goto continue
            --       ::continue::
            --     end
            --     local key = line:sub(1, equalIndex - 1)
            --     local value = line:sub(equalIndex + 1)
            --     vim.fn.setenv(key, value)
            --   end
            -- end
            vim.cmd("DBUIToggle")
          end,
          desc = "[L]aunch Database Client",
        },
      }
    end,
  },
}
