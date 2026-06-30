-- Clear startup screen
vim.opt.shortmess:append("I")

-- Show absolute line number on the line where the cursor is, and relative line numbers on other lines
vim.opt.number = true
vim.opt.relativenumber = true

-- Force enable line numbers in terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.opt_local.number = true
		vim.opt_local.relativenumber = true
	end,
})

-- Force enable line numbers in folder buffers
vim.g.netrw_bufsettings = 'noma nomod nu rnu nobl nowrap ro'

-- Always show at least 6 lines above and below the cursor
vim.opt.scrolloff = 6

-- Set terminal cursor appearence the same as the regular cursor
vim.opt.guicursor =
	"n-v-c-sm:block," ..
	"i-ci-ve:ver25," ..
	"r-cr-o:hor20," ..
	"t:ver25-blinkon500-blinkoff500-TermCursor," ..
	"a:SmearCursorHideable"

-- Set a character for trailing whitespaces
vim.opt.list = true
vim.opt.listchars = {
	tab = "  ",
	trail = "•",
}

-- Enable persistent undo memory
vim.opt.undofile = true

-- Run the following commands everytime after opening any file
-- This ensures that they are not overwritten by any language specific configs
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		-- Set TAB size and avoid being substituted by spaces
		vim.opt.tabstop = 4
		vim.opt.shiftwidth = 4
		vim.opt.softtabstop = 0
		vim.opt.expandtab = false

		-- Disable auto commenting on new line
		vim.opt_local.formatoptions:remove({ "r", "o" })
	end
})

