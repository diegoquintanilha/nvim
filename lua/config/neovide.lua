if vim.g.neovide then
	-- Open Neovide in fullscreen mode
	vim.g.neovide_fullscreen = true
	
	-- Change font size with Ctrl+MouseScroll
	vim.g.neovide_scale_factor = 1.0
	vim.keymap.set("n", "<C-ScrollWheelUp>", function()
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.05
		vim.cmd("normal! zz")
	end)

	vim.keymap.set("n", "<C-ScrollWheelDown>", function()
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 0.95
		vim.cmd("normal! zz")
	end)
	
	-- Do not animate cursor in insert mode
	vim.g.neovide_cursor_animate_in_insert_mode = false

	-- Cursor animation
	vim.g.neovide_cursor_animation_length = 0.04
	vim.g.neovide_cursor_short_animation_length = 0.0
	
	-- Scroll animation
	vim.g.neovide_scroll_animation_length = 0.04
	vim.g.neovide_scroll_animation_far_lines = 9999
end

