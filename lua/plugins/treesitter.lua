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

			-- Loop backwards from current line
			for i = #lines, 1, -1 do
				-- Check each of the previous lines to see if the current line is inside a custom fold
				local prev_line = lines[i]

				if prev_line:find("^%s*#%s*region.*") or prev_line:find("^%s*#pragma%s+region.*") then
					-- The current line is inside a custom fold
					local char, num = fold:match("^([^%d]?)(%d*)$") -- Separate the number part
					if num == "" then return fold end -- If there is no number, return base fold
					return char .. tostring(tonumber(num) + 1) -- Increment the fold level
				elseif prev_line:find("^%s*#%s*endregion.*") or prev_line:find("^%s*#pragma%s+endregion.*") then
					-- The current line is not inside a custom fold
					return fold -- Return base fold
				end
			end

			-- At the end of the loop, if no custom folds have been found, return the base Treesitter fold
			return fold
		end

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

			-- Check if indentation of first and last line of the fold match
			if start_indent_count == end_indent_count then

				-- Check for open bracket or brace at the beginning of the second line
				local second_line_first_char = vim.fn.getline(line_start + 1):gsub("^%s*", ""):sub(1, 1)
				local second_line_indent_count = vim.fn.indent(line_start + 1)
				if second_line_indent_count == start_indent_count and (second_line_first_char == "(" or second_line_first_char == "{") then
					-- Include open bracket or brace in the fold text
					start_text = start_text .. " " .. second_line_first_char
				end

				-- If indentation matches, use both first and last lines on fold text
				return indent_spaces .. "▶  " .. start_text .. " [+" .. line_count .. " lines] " .. end_text
			else
				-- If indentation does not match, use only the text of the first line
				return indent_spaces .. "▶  " .. start_text .. " [+" .. line_count .. " lines]"
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
	end
}

