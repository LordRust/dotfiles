require("mymodule")

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.undofile = true -- undo after quitting and resuing editing
-- vim.opt.termguicolors = true
-- vim.opt.wrap = true
-- saner(?) splits
-- vim.opt.splitbelow = true
-- vim.opt.splitright = true
-- vim.opt.path+=**
-- vim.cmd('colorscheme koehler')
-- vim.o.background = "dark"
-- vim.cmd.colorscheme "tango-dark"
vim.cmd.colorscheme "retrobox"

-- vim.g.mapleader = " " -- normal mapleader is \

-- current file name, and whether it’s been modified on the left-hand side of the statusline, and the filetype, hexadecimal value of the character currently under the cursor, current cursor position (line and column), and how far along we are in the file in percent on the right-hand side.
vim.opt.statusline = "%f%m%=%y 0x%B %l:%c %p%%"

vim.opt.showcmd = true
-- colorscheme needs to be loaded as a plugin "https://github.com/vague2k/vague.nvim"

-- TABS
vim.opt.expandtab = false -- use tabs, not spaces
vim.opt.tabstop = 4 -- a tab looks like 4 spaces
vim.opt.shiftwidth = 4 -- size of an indent
vim.opt.softtabstop = 0 -- keeps the tab from doing "smart" spaces insertions

-- Force the cursor to the start of the tab by enabling list mode
vim.opt.list = true

-- Define listchars: the first char is the lead, second is the filler
-- Here we set them to simple spaces to keep the UI clean
vim.opt.listchars = { tab = '>-', trail = '·' }





