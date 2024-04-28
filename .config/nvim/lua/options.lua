
local opt = vim.opt

opt.number = true

-- Set leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- Enable incremental searching
opt.incsearch = true
opt.hlsearch = true

-- Enable smart indenting (see https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)
opt.breakindent = true

opt.wrap = false -- Disable text wrap

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- Enable mouse mode
opt.mouse = "a"

-- Enable persistent undo history
opt.undofile = true

-- Always keep 8 lines above/below cursor unless at start/end of file
opt.scrolloff = 8

-- Place a column line (Not sure that i wanted)
-- vim.opt.colorcolumn = "120"
