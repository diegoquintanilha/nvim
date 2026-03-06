-- Clear startup screen
vim.opt.shortmess:append("I")

-- Show absolute line number on the line where the cursor is, and relative line numbers on other lines
vim.opt.number = true
vim.opt.relativenumber = true

-- Set TAB size and avoid being substituted by spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 0
vim.opt.expandtab = false

-- Prevent python ftplugin from overriding tab settings
vim.g.python_recommended_style = 0

