
local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true
opt.number = true

-- curserline is highlighted
opt.cursorline = true


-- tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- line wraping
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true


-- appearance 
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- split windows
opt.splitright = true
opt.splitbelow = true

-- don't allow cursor to be at top of bottom 
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")


