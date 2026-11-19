-- Create user command to print all currently stored buffers
vim.api.nvim_create_user_command("H", function()
	local lines = { "--- CHEAT SHEET ---\n" }

	table.insert(lines, " BUFFERS                                                   |")
	table.insert(lines, "   <TAB>            -> Go to previous buffer               |")
	table.insert(lines, "   <SPACE> f b      -> Find buffer                         |")
	table.insert(lines, "   <SPACE> b [rewq] -> Store current buffer on slot [rewq] |")
	table.insert(lines, "   <SPACE> [rewq]   -> Go to buffer stored on slot [rewq]  |")
	table.insert(lines, "   :BufferSlots     -> Show buffers stored on each slot    |")
	table.insert(lines, "   :ls              -> Show all buffers                    |")
	table.insert(lines, "   :b[N]            -> Go to buffer number N               |")
	table.insert(lines, "   :bd[N]           -> Delete buffer number N              |")
	table.insert(lines, "   :bd              -> Delete current buffer               |")
	table.insert(lines, "                                                           |")
	
	table.insert(lines, " FILES                                                     |")
	table.insert(lines, "   <SPACE> f f   -> Find file in current folder            |")
	table.insert(lines, "   <SPACE> f r   -> Find recently opened file              |")
	table.insert(lines, "   :e [filename] -> Open [filename]                        |")
	table.insert(lines, "   :enew         -> Open new empty file                    |")
	table.insert(lines, "                                                           |")
	
	table.insert(lines, " SPLITS                                                    |")
	table.insert(lines, "   :split         -> Horizontal split                      |")
	table.insert(lines, "   :vsplit        -> Vertical split                        |")
	table.insert(lines, "   <SPACE> [hjkl] -> Go to split in [hjkl] direction       |")
	table.insert(lines, "   <SPACE> o      -> Maximize current split                |")
	table.insert(lines, "                                                           |")
	
	lines[ 2] = lines[ 2] .. " COMPILATION"
	lines[ 3] = lines[ 3] .. "   :Cmd [vcxz]    -> Store command on slot [vcxz]"
	lines[ 4] = lines[ 4] .. "   <SPACE> [vcxz] -> Run command on slot [vcxz]"
	lines[ 5] = lines[ 5] .. "   :CmdSlots      -> Show commands stored on each slot"
	lines[ 6] = lines[ 6] .. "   :CmdOut        -> See output of last command"
	lines[ 7] = lines[ 7] .. "   <SPACE> t t    -> Open terminal"
	lines[ 8] = lines[ 8] .. "   <SPACE> t q    -> Put selection into the quickfix list"
	lines[ 9] = lines[ 9] .. "   Ctrl+[hl]      -> Go to previous/next compilation error"
	lines[10] = lines[10] .. ""
	
	lines[11] = lines[11] .. " ALIGN"
	lines[12] = lines[12] .. "   <SPACE> a a -> Align selection to the right of the pattern"
	lines[13] = lines[13] .. "   <SPACE> a l -> Align selection to the left of the pattern"
	lines[14] = lines[14] .. "   <SPACE> a _ -> Align selection to the first character"
	
	table.insert(lines, " COLOR THEME")
	table.insert(lines, "   :Color                 -> Print all colors of current color theme")
	table.insert(lines, "   :Color [theme]         -> Change to the given color theme")
	table.insert(lines, "   :Color [group]         -> Print color of the given syntax group")
	table.insert(lines, "   :Color [group] [color] -> Change color of the given syntax group")

	vim.api.nvim_out_write(table.concat(lines, "\n") .. "\n\n")
end, {})


