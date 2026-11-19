vim.o.statusline = table.concat({
	" ", -- Left padding

	"[%{v:lua.get_buffer_slot()}] ", -- Buffer number or slot
	"%<%f",  -- File path (may be truncated)

	-- Optional section
	"%(",
		" ",
		"%h", -- Help buffer indicator
		"%w", -- Preview window indicator
		"%m", -- Modified buffer indicator
		"%r", -- Read-only buffer indicator
		"%{ v:lua.require('vim._core.util').term_exitcode() }", -- Terminal exit code
	"%)",

	"%=", -- Right-align everything that follows

	-- Search match count (optional, minimum width 10, left-aligned)
	-- "%(%-10S %)",

	-- Busy indicator
	"%{ &busy > 0 ? '◐ ' : '' }",

	-- Optional section
	"%(",
		-- UI progress indicator
		"%{ luaeval('(package.loaded[''vim.ui''] and vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin or -1) and vim.ui.progress_status()) or '''' ') }",
		" ",
	"%)",

	-- Macro recording indicator
	-- "%(%k %)",

	-- Line and column
	"%l:%c (%p%%)",
	
	" ", -- Right padding
})

