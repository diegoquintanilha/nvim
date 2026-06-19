-- Table that holds stored commands per slot
local stored_commands = {
	z = nil,
	x = nil,
	c = nil,
	v = nil,
}
local command_slot_priority = { "v", "c", "x", "z" }

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

-- Run the command stored on the given slot
local function run_command(slot)
	-- Check if there is a valid command stored in the given slot
	if not stored_commands[slot] then
		vim.notify("Error: No stored command on slot '".. slot .."'", vim.log.levels.ERROR)
		return
	end
	
	print("Running command: " .. stored_commands[slot])
	
	-- Close the quickfix list, if it is open
	vim.cmd("cclose")
	-- Save all files
	vim.cmd("wall")
	-- Open new buffer
	vim.cmd("enew")
	local term_buf = vim.api.nvim_get_current_buf()
	
	-- Transform the new buffer into a terminal window and run the stored command
	vim.fn.termopen(stored_commands[slot], {
		on_exit = function()
			-- If the command ran successfully, just exit
			if code == 0 then
				vim.api.nvim_buf_delete(term_buf, { force = true })
				return
			end
			
			-- If the command did not return 0, get the contents of the terminal
			local lines = vim.api.nvim_buf_get_lines(term_buf, 0, -1, false)
			
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
			
			-- Check if there were any successfully parsed compiler errors
			local valid = false
			for _, info in ipairs(vim.fn.getqflist()) do
				if info.valid == 1 then
					valid = true
					break
				end
			end
			
			-- If no lines are compiler errors, clear the quickfix list and exit
			if not valid then
				vim.fn.setqflist({})
				vim.api.nvim_buf_delete(term_buf, { force = true })
				return
			end

			-- If there was at least one compiler error, close the terminal and open the quickfix list
			vim.api.nvim_buf_delete(term_buf, { force = true })
			vim.cmd("copen")
			
			-- Open the file of the first error in the list, in case it is not opened
			vim.cmd("cc")
			
			-- For whatever reason, two nested schedules are required for this to work
			vim.schedule(function() vim.schedule(function()
				vim.cmd("cc") -- Move the cursor to the first error
				vim.cmd("normal! zz") -- Center the screen
			end) end)
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

-- Run command in z, x, c or v
vim.keymap.set("n", "<LEADER>z", function() run_command("z") end)
vim.keymap.set("n", "<LEADER>x", function() run_command("x") end)
vim.keymap.set("n", "<LEADER>c", function() run_command("c") end)
vim.keymap.set("n", "<LEADER>v", function() run_command("v") end)

-- Standard remap options
local opts = { noremap = true, silent = true }

-- Navigate the quickfix list with Ctrl+H and Ctrl+L
vim.keymap.set("n", "<C-h>", ":cprev<CR>", opts)
vim.keymap.set("n", "<C-l>", ":cnext<CR>", opts)

-- Open a new terminal window with Q
vim.keymap.set("n", "Q", ":term<CR>i", opts)

-- When exiting from the terminal, close the buffer instantly
vim.api.nvim_create_autocmd("TermClose", {
	callback = function(args)
		-- Two nested schedules are required to guarantee that this runs after the 'on_exit' callback
		vim.schedule(function() vim.schedule(function()
			if vim.api.nvim_buf_is_valid(args.buf) then
				vim.api.nvim_buf_delete(args.buf, { force = true })
			end
		end) end)
	end,
})

