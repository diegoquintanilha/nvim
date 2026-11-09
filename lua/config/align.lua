-- Align selection based on the given pattern
local function align_selection(inclusive, pattern)
	if vim.fn.mode() ~= "V" then
		vim.notify("Error: Must be in visual line mode to align block", vim.log.levels.ERROR)
		return
	end

	-- Get the pattern to align to
	local input_string = inclusive and "Align: " or "Left align: "
	pattern = vim.fn.input(input_string, pattern or "")
	if pattern == "" then
		-- If no pattern is given, align to equal sign if inclusive, or to colon if not inclusive
		pattern = inclusive and "=" or ":"
	end
	local plain_text = pattern:find("%", 1, true) == nil

	-- Get the selected lines
	local selection_start = vim.fn.line("v")
	local selection_end = vim.fn.line(".")
	if selection_start > selection_end then
		selection_start, selection_end = selection_end, selection_start
	end
	selection_start = selection_start - 1
	local lines = vim.api.nvim_buf_get_lines(0, selection_start, selection_end, false)

	-- Find all occurrences and positions of the pattern
	local target_col = 0
	local occurrences = {}
	for i, line in ipairs(lines) do
		-- Get the position (character count) of the pattern
		local pos = line:find(pattern, 1, plain_text)
		if pos then
			-- Get the column of the pattern
			local col = vim.fn.strdisplaywidth(line:sub(1, pos - 1))
			occurrences[i] = {
				pos = pos,
				col = col,
			}
			-- Keep track of the rightmost occurrence of the pattern
			if col > target_col then
				target_col = col
			end
		end
	end

	for i, occurrence in pairs(occurrences) do
		-- Calculate how many spaces are needed to put each pattern in the same column as the rightmost one
		local spaces = string.rep(" ", target_col - occurrence.col)
		local line = lines[i]
		if inclusive then
			-- Fill with spaces before the pattern
			lines[i] = line:sub(1, occurrence.pos - 1) .. spaces .. line:sub(occurrence.pos)
		else
			-- Fill with spaces after the pattern
			lines[i] = line:sub(1, occurrence.pos) .. spaces .. line:sub(occurrence.pos + 1)
		end
	end

	-- Apply the modifications to the current buffer
	vim.api.nvim_buf_set_lines(0, selection_start, selection_end, false, lines)

	-- Exit visual mode
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "x", false)
end

-- Keymap to align selection
vim.keymap.set("x", "<LEADER>aa", function() align_selection(true) end)
vim.keymap.set("x", "<LEADER>al", function() align_selection(false) end)
vim.keymap.set("x", "<LEADER>a_", function() align_selection(true, "%S") end)

