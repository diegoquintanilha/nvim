-- Table that holds stored buffers per slot
local stored_buffers = {
	q = nil,
	w = nil,
	e = nil,
	r = nil,
}
local buffer_slot_priority = { "r", "e", "w", "q" }

-- Save current buffer into a slot
local function save_buffer(slot)
	stored_buffers[slot] = vim.api.nvim_get_current_buf()
	print("Saved buffer " .. stored_buffers[slot] .. " to slot '" .. slot .. "'")
end

-- Go to buffer stored in a slot
local function go_to_buffer(slot)
	local buf = stored_buffers[slot]
	if buf and vim.api.nvim_buf_is_valid(buf) then
		vim.api.nvim_set_current_buf(buf)
	else
		vim.notify("No valid buffer in slot '" .. slot .. "'", vim.log.levels.ERROR)
	end
end

-- Automatically save a new buffer into the first available slot
local function auto_save_buffer(buf)
	-- Skip buffers that are already assigned
	for _, saved in pairs(stored_buffers) do
		if saved == buf then
			return
		end
	end

	-- Skip buffers that don't show up in :ls
	if vim.fn.buflisted(buf) ~= 1 then
		return
	end

	-- Check slot availability according to the priority
	for _, slot in ipairs(buffer_slot_priority) do
		local buf_slot = stored_buffers[slot]
		if not buf_slot or not vim.api.nvim_buf_is_valid(buf_slot) then
			stored_buffers[slot] = buf
			return
		end
	end
end

-- Call auto_save_buffer for all buffers when starting Neovim
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			auto_save_buffer(buf)
		end
	end,
})
-- Call auto_save_buffer for every new buffer
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function(args)
		auto_save_buffer(args.buf)
	end,
})

-- Create user command to print all currently stored buffers
vim.api.nvim_create_user_command("BufferSlots", function()
	local lines = { "Buffer Slots:" }
	
	for _, slot in ipairs(buffer_slot_priority) do
		local buf = stored_buffers[slot]

		if buf and vim.api.nvim_buf_is_valid(buf) then
			local name = vim.api.nvim_buf_get_name(buf)
			if name == "" then
				name = "[No Name]"
			end

			table.insert(lines, string.format("%s -> b%d %s", slot, buf, name))
		else
			table.insert(lines, string.format("%s -> [empty]", slot))
		end
	end

	vim.api.nvim_out_write(table.concat(lines, "\n") .. "\n")
end, {})

-- Store current buffer in q, w, e or r
vim.keymap.set("n", "<LEADER>bq", function() save_buffer("q") end)
vim.keymap.set("n", "<LEADER>bw", function() save_buffer("w") end)
vim.keymap.set("n", "<LEADER>be", function() save_buffer("e") end)
vim.keymap.set("n", "<LEADER>br", function() save_buffer("r") end)

-- Go to stored buffer in q, w, e or r
vim.keymap.set("n", "<LEADER>q", function() go_to_buffer("q") end)
vim.keymap.set("n", "<LEADER>w", function() go_to_buffer("w") end)
vim.keymap.set("n", "<LEADER>e", function() go_to_buffer("e") end)
vim.keymap.set("n", "<LEADER>r", function() go_to_buffer("r") end)

-- Standard remap options
local opts = { noremap = true, silent = true }

-- Movement between splits
vim.keymap.set("n", "<LEADER>h", "<C-w>h", opts)
vim.keymap.set("n", "<LEADER>j", "<C-w>j", opts)
vim.keymap.set("n", "<LEADER>k", "<C-w>k", opts)
vim.keymap.set("n", "<LEADER>l", "<C-w>l", opts)

-- Maximize current buffer
vim.keymap.set("n", "<LEADER>o", "<C-w>o", opts)

-- Toggle to last buffer with Tab
vim.keymap.set("n", "<TAB>", ":buffer #<CR>", opts)

