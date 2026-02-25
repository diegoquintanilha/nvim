-- Only redraw screen at the end of commands
vim.opt.lazyredraw = true

-- Disable timeout for mapped sequences
vim.opt.timeout = false

-- Map the <LEADER> key to space
vim.g.mapleader = " "

-- Standard options for all remaps
local opts = { noremap = true, silent = true }

-- Save all and run last command
vim.keymap.set("n", "<LEADER>g", ":wall | !!<CR>", opts)

-- Toggle to last buffer with Tab
vim.keymap.set("n", "<Tab>", ":buffer #<CR>", opts)

-- Movement in insert mode
vim.keymap.set("i", "<C-h>", "<Left>",  opts)
vim.keymap.set("i", "<C-j>", "<Down>",  opts)
vim.keymap.set("i", "<C-k>", "<Up>",    opts)
vim.keymap.set("i", "<C-l>", "<Right>", opts)

-- Move screen with cursor using Ctrl+J / Ctrl+K
vim.keymap.set("n", "<C-j>", "j<C-e>", opts)
vim.keymap.set("n", "<C-k>", "k<C-y>", opts)
vim.keymap.set("x", "<C-j>", "j<C-e>", opts)
vim.keymap.set("x", "<C-k>", "k<C-y>", opts)

-- Keep cursor centered with Ctrl+U / Ctrl+D
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("x", "<C-u>", "<C-u>zz", opts)
vim.keymap.set("x", "<C-d>", "<C-d>zz", opts)

-- Add line below / above without leaving normal mode
vim.keymap.set("n", "co", "m`o<ESC>``", opts)
vim.keymap.set("n", "cO", "m`O<ESC>``", opts)

-- Keep cursor still when joining lines
vim.keymap.set("n", "J", "m`J``", opts)

-- Drag lines up or down using ALT+J / ALT+K
vim.keymap.set("n", "<M-j>", ":m +1<CR>==", opts)
vim.keymap.set("n", "<M-k>", ":m -2<CR>==", opts)
vim.keymap.set("x", "<M-j>", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("x", "<M-k>", ":m '<-2<CR>gv=gv", opts)

-- Paste over selection without overwriting buffer
vim.keymap.set("x", "<C-p>", '"_dP', opts)
vim.keymap.set("n", "<C-p>", "p", opts) -- Alias for normal mode

-- Put open parenthesis / bracket on new line
vim.keymap.set("n", "c(", "m`0f(i<CR><ESC>``", opts)
vim.keymap.set("n", "c{", "m`0f{i<CR><ESC>``", opts)

-- Create new code block in insert mode
vim.keymap.set("i", "<C-b>", "<CR>(<CR>)<ESC>O", opts)
vim.keymap.set("i", "<C-r>", "<CR>{<CR>}<ESC>O", opts)

-- Surround selected text
vim.keymap.set("x", "g(", "c()<ESC>P", opts)
vim.keymap.set("x", "g[", "c[]<ESC>P", opts)
vim.keymap.set("x", "g{", "c{}<ESC>P", opts)
vim.keymap.set("x", "g<", "c<><ESC>P", opts)
vim.keymap.set("x", "g'", "c''<ESC>P", opts)
vim.keymap.set("x", 'g"', 'c""<ESC>P', opts)

-- Remove surrounding symbol
vim.keymap.set("n", "dg(", "m`yi(va(p``", opts)
vim.keymap.set("n", "dg[", "m`yi[va[p``", opts)
vim.keymap.set("n", "dg{", "m`yi{va{p``", opts)
vim.keymap.set("n", "dg<", "m`yi<va<p``", opts)
vim.keymap.set("n", "dg'", "m`yi'va'p``", opts)
vim.keymap.set("n", 'dg"', 'm`yi"va"p``', opts)

