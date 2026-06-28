-- Table that holds stored commands per slot
local stored_commands = {
	z = nil,
	x = nil,
	c = nil,
	v = nil,
}
local command_slot_priority = { "v", "c", "x", "z" }

-- Variable that stores the output of the last terminal command
local output_last_cmd = nil

-- Store a command into the given slot
local function store_command(slot)
	stored_commands[slot] = vim.fn.input("Store command on slot '".. slot .."': ", stored_commands[slot] or "")
	vim.schedule(function() print("Command stored on slot '".. slot .."':", stored_commands[slot]) end)
end

-- Create user command to store terminal command
vim.api.nvim_create_user_command("Cmd", function(opts)
	local arg = vim.trim(opts.args or "")

	-- If cmd was called with no parameters, store the command on the first available slot
	if arg == "" then
		for _, slot in pairs(command_slot_priority) do
			if not stored_commands[slot] then
				store_command(slot)
				return
			end
		end
		vim.notify("Error: No free command slot. Select a specific slot with ':cmd [v|c|x|z]'", vim.log.levels.ERROR)
		return
	end
	
	-- If cmd was called with a parameter, validate it
	for _, slot in pairs(command_slot_priority) do
		if slot == arg then
			store_command(slot)
			return
		end
	end
	vim.notify("Error: '" .. arg .. "' is not a valid command slot", vim.log.levels.ERROR)
	
-- Capture 0 or 1 arguments
end, { nargs = "?" })

-- Create user command to print all stored terminal commands
vim.api.nvim_create_user_command("CmdSlots", function()
	local lines = { "Command Slots:" }
	
	for _, slot in ipairs(command_slot_priority) do
		local command = stored_commands[slot]
		if command then
			table.insert(lines, string.format("%s -> %s", slot, command))
		else
			table.insert(lines, string.format("%s -> [empty]", slot))
		end
	end

	vim.api.nvim_out_write(table.concat(lines, "\n") .. "\n")
end, {})

-- Parse the given lines as compiler errors and populate the quickfix list
local function lines_to_quickfix(lines)
	-- Remove empty lines
	clean = {}
	for _, line in ipairs(lines) do
		if line ~= "" then
			table.insert(clean, line)
		end
	end
	
	-- Parse the contents of the terminal as compiler errors
	local efm = table.concat({
		"%f:%l:%c: %trror: %m",
		"%f:%l:%c: %tarning: %m",
		"%f:%l: %trror: %m",
		"%f:%l: %tarning: %m",
	}, ",")
	
	-- Add the lines to the quickfix list
	vim.fn.setqflist({}, " ", {
		title = "Compilation errors",
		lines = clean,
		efm = efm,
	})
	
	-- If there were any successfully parsed compiler errors, return true
	for _, info in ipairs(vim.fn.getqflist()) do
		if info.valid == 1 then
			return true
		end
	end
	
	-- Otherwise, clear the quickfix list and return false
	vim.fn.setqflist({})
	return false
end

-- Open the quickfix list and navigate to the first error
local function qf_list_go_to_error()
	-- Open the quickfix list
	vim.cmd("copen")
	-- Open the file of the first error in the list, in case it is not opened
	vim.cmd("cc")
	-- For whatever reason, two nested schedules are required for this to work
	vim.schedule(function() vim.schedule(function()
		vim.cmd("cc") -- Move the cursor to the first error
		vim.cmd("normal! zz") -- Center the screen
	end) end)
end

-- Run the command stored on the given slot
local function run_command(slot)
	-- Check if there is a valid command stored in the given slot
	if not stored_commands[slot] then
		vim.notify("Error: No stored command on slot '".. slot .."'", vim.log.levels.ERROR)
		return
	end
	
	-- TODO: save cursor position here and restore after exiting the terminal
	
	-- Close the quickfix list, if it is open
	vim.cmd("cclose")
	-- Save all files
	vim.cmd("wall")
	-- Open new buffer
	vim.cmd("enew")
	local term_buf = vim.api.nvim_get_current_buf()
	
	print("Running command: " .. stored_commands[slot])
	
	-- Transform the new buffer into a terminal window and run the stored command
	vim.fn.termopen(stored_commands[slot], {
		on_exit = function(_, code)
			-- Get the contents of the terminal
			output_last_cmd = vim.api.nvim_buf_get_lines(term_buf, 0, -1, false)
			
			-- If the command ran successfully, just print the exit code
			if code == 0 then
				-- This 20 ms delay is a hack to avoid being overwritten by the default '-- TERMINAL --' text
				vim.defer_fn(function()
					if output_last_cmd then
						print("Command exited with code 0 (:CmdOut to see output)")
					else
						print("Command exited with code 0")
					end
				end, 20)
				return
			end
			-- Otherwise try parsing the contents of the terminal as errors for the quickfix list

			-- Try populating the quickfix list, parsing the terminal output as compiler errors
			local valid = lines_to_quickfix(output_last_cmd)
			
			-- Print the exit code
			-- This 20 ms delay is a hack to avoid being overwritten by the default '-- TERMINAL --' text
			vim.defer_fn(function()
				if not valid and output_last_cmd then
					vim.notify("Command exited with code ".. code .. " (:CmdOut to see output)", vim.log.levels.ERROR)
				else
					vim.notify("Command exited with code ".. code, vim.log.levels.ERROR)
				end
			end, 20)
			
			-- If there was at least one compiler error, open the quickfix list and go to the first error
			if valid then
				qf_list_go_to_error()
			end
		end
	})
	
	vim.cmd("startinsert")
end

-- Custom function to print the quickfix list
function _G.QuickfixListText(qf)
	local qf_list = vim.fn.getqflist({ id = qf.id, items = 1 })
	local lines = {}
	for _, info in ipairs(qf_list.items) do
		
		if info.valid ~= 1 then
			-- If the line is not a valid error, just print its text
			table.insert(lines, info.text or "")
			
		else
			local filename = "[no file]"
			if info.bufnr > 0 then
				-- Get file name from buffer
				local full_name = vim.api.nvim_buf_get_name(info.bufnr)
				filename = vim.fs.basename(full_name)
			elseif item.filename and item.filename ~= "" then
				-- Read file name directly from table
				filename = item.filename
			end
			
			-- Get error type
			if info.type == "e" then
				table.insert(lines, string.format("%s:%d:%d: error: %s", filename, info.lnum, info.col, info.text or ""))
			elseif info.type == "w" then
				table.insert(lines, string.format("%s:%d:%d: warning: %s", filename, info.lnum, info.col, info.text or ""))
			elseif info.type == "" then
				table.insert(lines, string.format("%s:%d:%d: %s", filename, info.lnum, info.col, info.text or ""))
			else
				table.insert(lines, string.format("%s:%d:%d: %s: %s", info.type, filename, info.lnum, info.col, info.text or ""))
			end
		end
	end

	return lines
end
vim.o.quickfixtextfunc = "v:lua.QuickfixListText"

-- Create user command to print the output of the last terminal command
vim.api.nvim_create_user_command("CmdOut", function()
	if output_last_cmd then
		print("Output of last terminal command:\n" .. table.concat(output_last_cmd, "\n"))
	else
		vim.notify("No terminal output available.", vim.log.levels.ERROR)
	end
end, {})

-- Run command in z, x, c or v
vim.keymap.set("n", "<LEADER>z", function() run_command("z") end)
vim.keymap.set("n", "<LEADER>x", function() run_command("x") end)
vim.keymap.set("n", "<LEADER>c", function() run_command("c") end)
vim.keymap.set("n", "<LEADER>v", function() run_command("v") end)

-- Parse the selected lines as compiler errors and put them into the quickfix list
vim.keymap.set("x", "<LEADER>q", function()
	-- Exit visual mode
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "x", false)
	
	-- Get last selected lines
	local selection_start = vim.fn.line("'<") - 1
	local selection_end = vim.fn.line("'>")
	local lines = vim.api.nvim_buf_get_lines(0, selection_start, selection_end, false)
	
	-- Try populating the quickfix list, parsing the current slection as compiler errors
	local valid = lines_to_quickfix(lines)
	
	-- If there was at least one compiler error, open the quickfix list and go to the first error
	if valid then
		qf_list_go_to_error()
	else
		vim.notify("The current selection contains no compiler errors", vim.log.levels.ERROR)
	end
end)

-- Standard remap options
local opts = { noremap = true, silent = true }

-- Navigate the quickfix list with Ctrl+H and Ctrl+L
vim.keymap.set("n", "<C-h>", ":cprev<CR>zz", opts)
vim.keymap.set("n", "<C-l>", ":cnext<CR>zz", opts)

-- Open a new terminal window with Q
vim.keymap.set("n", "Q", ":term<CR>i", opts)

-- When the terminal exits, close the buffer instantly
vim.api.nvim_create_autocmd("TermClose", {
	callback = function(args)
		-- Two nested schedules are required to guarantee that this runs after the 'on_exit' callback
		vim.schedule(function() vim.schedule(function()
			-- If buffer still exists, close it
			if vim.api.nvim_buf_is_valid(args.buf) then
				vim.api.nvim_buf_delete(args.buf, { force = true })
			end
		end) end)
	end,
})

