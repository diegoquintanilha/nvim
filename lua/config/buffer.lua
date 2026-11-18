-- Table that holds stored buffers per slot
local stored_buffers = {
	q = nil,
	w = nil,
	e = nil,
	r = nil,
}
local buffer_slot_priority = { "r", "e", "w", "q" }

-- Store current buffer into a slot
local function store_buffer(slot)
	stored_buffers[slot] = vim.api.nvim_get_current_buf()
	print("Stored buffer " .. stored_buffers[slot] .. " in slot '" .. slot .. "'")
end

-- Go to buffer stored in the given slot
local function go_to_buffer(slot)
	local buf = stored_buffers[slot]
	if buf and vim.api.nvim_buf_is_valid(buf) then
		if vim.g.neovide then
			-- Save the current scroll animation length
			local animation = vim.g.neovide_scroll_animation_length
			-- Disable scroll animation
			vim.g.neovide_scroll_animation_length = 0
			-- Go to buffer
			vim.api.nvim_set_current_buf(buf)
			vim.cmd("normal! zz")
			-- Restore scroll animation
			vim.defer_fn(function()
				vim.g.neovide_scroll_animation_length = animation
			end, 20)
		else
			vim.api.nvim_set_current_buf(buf)
			vim.cmd("normal! zz")
		end
	else
		stored_buffers[slot] = nil -- In case it is storing an old, invalid buffer
		vim.notify("No valid buffer in slot '" .. slot .. "'", vim.log.levels.ERROR)
	end
end

-- Store all buffers into the available slots when starting Neovim
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			-- Store buffers in slots according to the slot priority
			for _, slot in ipairs(buffer_slot_priority) do
				if not stored_buffers[slot] then
					stored_buffers[slot] = buf
					break
				end
			end
		end
	end,
})

-- Create user command to print all currently stored buffers
vim.api.nvim_create_user_command("BufferSlots", function()
	local lines = { "Buffer Slots:" }
	
	for _, slot in ipairs(buffer_slot_priority) do
		local buf = stored_buffers[slot]

		if buf and vim.api.nvim_buf_is_valid(buf) then
			-- Print buffer name (if it has one)
			local name = vim.api.nvim_buf_get_name(buf)
			if name == "" then
				name = "[No Name]"
			end
			table.insert(lines, string.format("%s -> b%d %s", slot, buf, name))
		else
			stored_buffers[slot] = nil -- In case it is storing an old, invalid buffer
			table.insert(lines, string.format("%s -> [empty]", slot))
		end
	end

	vim.api.nvim_out_write(table.concat(lines, "\n") .. "\n")
end, {})

-- Store current buffer in q, w, e or r
vim.keymap.set("n", "<LEADER>bq", function() store_buffer("q") end)
vim.keymap.set("n", "<LEADER>bw", function() store_buffer("w") end)
vim.keymap.set("n", "<LEADER>be", function() store_buffer("e") end)
vim.keymap.set("n", "<LEADER>br", function() store_buffer("r") end)

-- Go to stored buffer in q, w, e or r
vim.keymap.set("n", "<LEADER>q", function() go_to_buffer("q") end)
vim.keymap.set("n", "<LEADER>w", function() go_to_buffer("w") end)
vim.keymap.set("n", "<LEADER>e", function() go_to_buffer("e") end)
vim.keymap.set("n", "<LEADER>r", function() go_to_buffer("r") end)

-- Go to previous buffer
vim.keymap.set("n", "<TAB>", function()
	if vim.g.neovide then
		-- Save the current scroll animation length
		local animation = vim.g.neovide_scroll_animation_length
		-- Disable scroll animation
		vim.g.neovide_scroll_animation_length = 0
		-- Go to buffer
		vim.cmd("buffer #")
		vim.cmd("normal! zz")
		-- Restore scroll animation
		vim.defer_fn(function()
			vim.g.neovide_scroll_animation_length = animation
		end, 20)
	else
		vim.cmd("buffer #")
		vim.cmd("normal! zz")
	end
end)

