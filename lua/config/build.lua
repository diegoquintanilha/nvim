local stored_command = nil

vim.keymap.set("n", "<LEADER>c", function()
	stored_command = vim.fn.input("Build command: ")
	print("Stored build command: " .. stored_command)
end)

-- Find any terminal buffer, visible or hidden
local function find_terminal_buffer()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf)
			and vim.bo[buf].buftype == "terminal"
		then
			return buf
		end
	end

	return nil
end

-- Find window showing a specific buffer
local function find_window_for_buffer(buf)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == buf then
			return win
		end
	end

	return nil
end

vim.keymap.set("n", "<LEADER>g", function()
	if not stored_command then
		print("No stored build command")
		return
	end

	print("Running command: " .. stored_command)
	
	-- Save all files
	vim.cmd("wall")
	
	-- Check if there is a terminal buffer
	local term_buf = find_terminal_buffer()
	
	if not term_buf then
		-- If there is no terminal buffer, create one on a separate split
		vim.cmd("split")
		vim.cmd("terminal")
		term_buf = vim.api.nvim_get_current_buf()
	else
		-- If there is a terminal buffer, check if it has a split
		local win = find_window_for_buffer(term_buf)

		if win then
			-- If it does, reuse it
			vim.api.nvim_set_current_win(win)
		else
			-- If it doesn't, create one
			vim.cmd("split")
			vim.api.nvim_win_set_buf(0, term_buf)
		end	
	end

	-- Send command to the terminal
	local job_id = vim.b[term_buf].terminal_job_id
	vim.fn.chansend(job_id, stored_command .. "\r")
	
	-- Go to insert mode
	vim.cmd("startinsert")
end)

