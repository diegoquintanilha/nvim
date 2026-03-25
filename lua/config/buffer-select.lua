-- Table holding saved buffers per slot
local saved_bufs = {
	q = nil,
	w = nil,
	e = nil,
	r = nil,
}

-- Save current buffer into a slot
local function save_buffer(slot)
	saved_bufs[slot] = vim.api.nvim_get_current_buf()
	print("Saved buffer " .. saved_bufs[slot] .. " to slot " .. slot)
end

-- Go to buffer stored in a slot
local function go_to_buffer(slot)
	local buf = saved_bufs[slot]
	if buf and vim.api.nvim_buf_is_valid(buf) then
		vim.api.nvim_set_current_buf(buf)
	else
		print("No valid buffer in slot " .. slot)
	end
end

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

-- Toggle to last buffer with Tab
vim.keymap.set("n", "<TAB>", ":buffer #<CR>", opts)

