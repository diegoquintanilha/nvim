return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		-- List of language parsers
		parsers = {
			"asm",
			"c",
			"cpp",
			"cmake",
			"glsl",
			"hlsl",
			"wgsl",
			"arduino",
			"python",
			"sql",
			"html",
			"javascript",
			"ini",
			"yaml",
			"toml",
			"c_sharp",
			"lua",
			"vim",
			"csv",
			"json",
			"xml",
			"markdown",
			"bash"
		}

		-- Install the above specified parsers
		require("nvim-treesitter").install(parsers)

		-- Helper function to check if the given position is inside a comment or a string
		function _G.is_valid_context(row, col)
			local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, row - 1, col - 1)
			if ok and captures then
				for _, capture in ipairs(captures) do
					local c = capture.capture
					if c == "comment" or c:find("string") then
						-- If Treesitter finds that the given position is inside a comment or a string, returns false
						return false
					end
				end
			end
			-- Treesitter didn't find a comment or string around the given position, so the context is valid
			return true
		end
		
		-- Custom function to calculate fold level with custom folds
		function _G.get_fold_level(lnum)
			-- Get Treesitter fold level
			local fold = vim.treesitter.foldexpr(lnum)
			
			-- Get all lines up to the current one
			local start = math.max(0, lnum - 1000) -- Custom folds may contain a maximum of 1000 lines
			local finish = lnum
			local lines = vim.api.nvim_buf_get_lines(0, start, finish, false)
			local current_line = lines[#lines]

			-- Match C, C++ and python custom folds
			if current_line:find("^%s*#%s*region.*") or current_line:find("^%s*#pragma%s+region.*") then
				return ">" .. tostring(tonumber(fold) + 1)
			elseif current_line:find("^%s*#%s*endregion.*") or current_line:find("^%s*#pragma%s+endregion.*") then
				return "<" .. tostring(tonumber(fold) + 1)
			end

			-- Check if the current line is inside a custom fold and increment if needed
			for i = #lines, 1, -1 do
				-- Loop backwards from current line
				-- Check each of the previous lines to see if the current line is inside a custom fold
				local prev_line = lines[i]

				if prev_line:find("^%s*#%s*region.*") or prev_line:find("^%s*#pragma%s+region.*") then
					-- The current line is inside a custom fold
					local char, num = fold:match("^([^%d]?)(%d*)$") -- Separate the number part
					if num ~= "" then -- If there is a number
						fold = char .. tostring(tonumber(num) + 1) -- Increment the fold level
					end
					break
				elseif prev_line:find("^%s*#%s*endregion.*") or prev_line:find("^%s*#pragma%s+endregion.*") then
					-- The current line is not inside a custom fold
					break -- Keep base fold
				end
			end

			-- Set every 'else' statement as a fold opener
			local else_start = current_line:find("%f[%w_]else%f[^%w_]")
			if else_start
				and not current_line:find(";") -- Ignore when the block ends on the same line
				and fold:find("^%d+$") -- Ignore when foldexpr is not a pure number
			then
				-- Ignore when 'else' is inside a comment or a string
				if is_valid_context(lnum, else_start) then
					fold = ">" .. tostring(tonumber(fold))
				end
			end
			
			return fold
		end

		-- Custom command to print fold level
		vim.api.nvim_create_user_command("FoldLevel", function()
			local line = vim.fn.line(".")
			local level = vim.fn.foldlevel(line)
			local expr = get_fold_level(line)
			print("Line: " .. line .. " | foldlevel: " .. level .. " | foldexpr: " .. expr)
		end, {})
		
		-- Custom function to generate fold text
		function _G.get_fold_text()
			-- Get start and end of the fold
			local line_start = vim.v.foldstart
			local line_end = vim.v.foldend
			local line_count = line_end - line_start

			-- Get the text on the first and last lines of the fold, removing indentation
			local start_text = vim.fn.getline(line_start):gsub("^%s*", "")
			local end_text = vim.fn.getline(line_end):gsub("^%s*", "")

			-- Get indentation count (in spaces)
			local start_indent_count = vim.fn.indent(line_start)
			local end_indent_count = vim.fn.indent(line_end)
			local indent_spaces = string.rep(" ", start_indent_count)

			-- Check for named custom folds (regions)
			local region_name = start_text:match("^%s*#%s*region%s+(.+)")
			if not region_name then
				region_name = start_text:match("^%s*#pragma%s+region%s+(.+)")
			end
			if region_name then
				-- If the region has an explicit name, the fold must simply reproduce it
				return indent_spaces .. region_name .. " [+" .. line_count .. " lines]"
			end

			-- Check if indentation of first and last line of the fold match
			if start_indent_count == end_indent_count then

				-- Check for open bracket or brace in other lines before the last, at the same indent level as the first line
				for i = line_start + 1, line_end - 1 do
					local middle_line_first_char = vim.fn.getline(i):match("%S")
					local middle_line_indent_count = vim.fn.indent(i)
					if middle_line_indent_count == start_indent_count and (middle_line_first_char == "(" or middle_line_first_char == "{") then
						-- Include open bracket or brace in the fold text
						start_text = start_text .. " " .. middle_line_first_char
						break
					end
				end

				-- If indentation matches, use both first and last lines on fold text
				return indent_spaces .. start_text .. " [+" .. line_count .. " lines] " .. end_text
			else
				-- If indentation does not match, use only the text of the first line
				return indent_spaces .. start_text .. " [+" .. line_count .. " lines]"
			end
		end

		-- Create a callback to run everytime a new file opens
		vim.api.nvim_create_autocmd("FileType", {
			pattern = parsers, -- Only run the callback for files that have a parser installed
			callback = function()
				-- Enable syntax highlighting (syntax highligting is enabled by default if Treesitter is running)
				vim.treesitter.start()
				-- Enable Treesitter folding
				vim.wo.foldmethod = "expr"
				vim.wo.foldexpr = "v:lua.get_fold_level(v:lnum)"
				vim.wo.foldtext = "v:lua.get_fold_text()"
				-- Enable Treesitter indentation
				--vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
		})
		
		-- Global folding options
		vim.opt.fillchars = { fold = " " }
		vim.opt.foldlevelstart = 99

		-- Save folds
		vim.opt.viewoptions = { "folds" }
		vim.api.nvim_create_autocmd("BufWritePost", { command = "silent! mkview" })
		vim.api.nvim_create_autocmd("BufReadPost", { callback = function()
			-- For whatever reason, two nested schedules are required for this to work
			vim.schedule(function() vim.schedule(function() vim.cmd("silent! loadview") end) end)
		end })
	end
}

