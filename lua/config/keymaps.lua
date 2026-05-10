-- Only redraw screen at the end of commands
vim.opt.lazyredraw = true

-- Disable timeout for mapped sequences
vim.opt.timeout = false

-- Map the <LEADER> key to space
vim.g.mapleader = " "

-- Standard options for all remaps
local opts = { noremap = true, silent = true }

-- Disable Q
vim.keymap.set("n", "Q", "<NOP>", opts)

-- Go back to normal mode with Ctrl+C
vim.keymap.set("i", "<C-c>", "<ESC>", opts)

-- Exit insert mode in terminal with ESC
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", opts)

-- Movement between splits
vim.keymap.set("n", "<LEADER>h", "<C-w>h", opts)
vim.keymap.set("n", "<LEADER>j", "<C-w>j", opts)
vim.keymap.set("n", "<LEADER>k", "<C-w>k", opts)
vim.keymap.set("n", "<LEADER>l", "<C-w>l", opts)

-- Movement in insert mode
vim.keymap.set("i", "<C-h>", "<LEFT>" , opts)
vim.keymap.set("i", "<C-j>", "<DOWN>" , opts)
vim.keymap.set("i", "<C-k>", "<UP>"   , opts)
vim.keymap.set("i", "<C-l>", "<RIGHT>", opts)

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

-- Keep cursor centered when browsing search results
vim.keymap.set("n", "n", "nzvzz", opts)
vim.keymap.set("n", "N", "Nzvzz", opts)

-- Search and replace selected
vim.keymap.set("x", "<C-h>", 'y:%s/<C-r><C-w>//g<LEFT><LEFT>', opts)
vim.keymap.set("x", "<LEADER>h", 'y:%s/<C-r><C-w>//gc<LEFT><LEFT><LEFT>', opts)

-- Clear search result highlighting
vim.keymap.set("n", "c/", ":nohlsearch<CR>", opts)

-- Insert true indentation on new lines
vim.keymap.set("i", "<CR>", "<CR> <BS>", opts)
vim.keymap.set("n", "o", "o <BS>", opts)
vim.keymap.set("n", "O", "O <BS>", opts)
vim.keymap.set("n", "cc", "cc <BS>", opts)
vim.keymap.set("x", "c", "c <BS>", opts)

-- Add line below / above without leaving normal mode
vim.keymap.set("n", "co", "m`o <BS><ESC>``", opts)
vim.keymap.set("n", "cO", "m`O <BS><ESC>``", opts)

-- Keep cursor still when joining lines
vim.keymap.set("n", "J", "m`J``", opts)

-- Drag lines up or down
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv", opts)

-- Paste over selection without overwriting buffer
vim.keymap.set("x", "<C-p>", '"_dP', opts)
vim.keymap.set("n", "<C-p>", "p", opts) -- Alias for normal mode

-- Alias for yanking to the system clipboard
vim.keymap.set("n", "<LEADER>y", '"+y', opts)
vim.keymap.set("n", "<LEADER>Y", '"+y$', opts)
vim.keymap.set("x", "<LEADER>y", '"+y', opts)

-- Alias for pasting from the system clipboard
vim.keymap.set("n", "<LEADER>p", '"+p', opts)
vim.keymap.set("n", "<LEADER>P", '"+P', opts)
vim.keymap.set("x", "<LEADER>p", '"+p', opts)
vim.keymap.set("x", "<LEADER>P", '"+P', opts)

-- Put open parenthesis / bracket on new line
vim.keymap.set("n", "c(", "m`0f(i<CR><ESC>``", opts)
vim.keymap.set("n", "c{", "m`0f{i<CR><ESC>``", opts)

-- Create new code block in insert mode
vim.keymap.set("i", "<C-b>", "<CR>(<CR>)<ESC>O <BS>", opts)
vim.keymap.set("i", "<C-r>", "<CR>{<CR>}<ESC>O <BS>", opts)

-- Surround selected text
vim.keymap.set("x", "sb", "c()<ESC>P", opts)
vim.keymap.set("x", "s(", "c()<ESC>P", opts)
vim.keymap.set("x", "s[", "c[]<ESC>P", opts)
vim.keymap.set("x", "s{", "c{}<ESC>P", opts)
vim.keymap.set("x", "s<", "c<><ESC>P", opts)
vim.keymap.set("x", "s'", "c''<ESC>P", opts)
vim.keymap.set("x", 's"', 'c""<ESC>P', opts)

-- Remove surrounding symbol
vim.keymap.set("n", "dsb", "m`yi(``va(p``", opts)
vim.keymap.set("n", "ds(", "m`yi(``va(p``", opts)
vim.keymap.set("n", "ds[", "m`yi[``va[p``", opts)
vim.keymap.set("n", "ds{", "m`yi{``va{p``", opts)
vim.keymap.set("n", "ds<", "m`yi<``va<p``", opts)
vim.keymap.set("n", "ds'", "m`yi'``va'p``", opts)
vim.keymap.set("n", 'ds"', 'm`yi"``va"p``', opts)

