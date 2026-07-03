-- Table that stores all the colors for the color scheme and syntax highlight groups
_G.colors = {
	-- Background colors
	background     = "#0A0303", -- Dark red
	highlight      = "#3A0707", -- Red
	-- background     = "#200505", -- Dark red (for darker monitors)
	-- highlight      = "#600808", -- Red (for darker monitors)
	search         = "#400070", -- Purple
	completion_box = "#011B41", -- Dark blue
	fold           = "#00D0D0", -- Cyan

	-- Syntax highlighting colors
	var          = "#DDDDDD", -- Light gray
	func         = "#FF8040", -- Orange
	type         = "#005EFF", -- Blue
	reserved     = "#FF0000", -- Red
	operator     = "#DDDD00", -- Yellow
	string       = "#40A040", -- Green
	escape       = "#004030", -- Dark green
	number       = "#00FF00", -- Light green
	preprocessor = "#FF00FF", -- Magenta
	comment      = "#707070", -- Gray
}

-- Get all colors in the table and apply them for their specific groups
local function apply_colors()
	-- Create wrapper table using the global colors
	local wrapper = {
		background     = { bg = colors.background },
		highlight      = { bg = colors.highlight },
		search         = { bg = colors.search },
		completion_box = { bg = colors.completion_box },
		fold           = { fg = colors.fold,         bold = true,  italic = false, nocombine = true },
		var            = { fg = colors.var,          bold = false, italic = false, nocombine = true },
		func           = { fg = colors.func,         bold = false, italic = false, nocombine = true },
		type           = { fg = colors.type,         bold = true,  italic = false, nocombine = true },
		reserved       = { fg = colors.reserved,     bold = false, italic = true , nocombine = true },
		operator       = { fg = colors.operator,     bold = false, italic = false, nocombine = true },
		string         = { fg = colors.string,       bold = false, italic = false, nocombine = true },
		escape         = { fg = colors.escape,       bold = false, italic = false, nocombine = true },
		number         = { fg = colors.number,       bold = false, italic = false, nocombine = true },
		preprocessor   = { fg = colors.preprocessor, bold = false, italic = false, nocombine = true },
		comment        = { fg = colors.comment,      bold = false, italic = false, nocombine = true },
	}
	
	-- Set editor window colors
	vim.api.nvim_set_hl(0, "Normal", wrapper.background)
	vim.api.nvim_set_hl(0, "Visual", wrapper.highlight)
	vim.api.nvim_set_hl(0, "WinSeparator", wrapper.comment)
	vim.api.nvim_set_hl(0, "IblIndent", wrapper.comment)
	
	vim.api.nvim_set_hl(0, "StatusLine", wrapper.highlight)
	vim.opt.laststatus = 3 -- Fix a single status bar
	
	vim.api.nvim_set_hl(0, "Search", wrapper.search)
	vim.api.nvim_set_hl(0, "CurSearch", wrapper.search)
	
	vim.api.nvim_set_hl(0, "LineNr", wrapper.var)
	vim.api.nvim_set_hl(0, "Folded", wrapper.fold)
	
	-- Set quickfix list colors
	vim.api.nvim_set_hl(0, "QuickFixLine", wrapper.highlight)
	
	-- Set LSP suggestion box colors
	vim.api.nvim_set_hl(0, "Pmenu", wrapper.completion_box)
	vim.api.nvim_set_hl(0, "PmenuSel", wrapper.highlight)
	vim.api.nvim_set_hl(0, "CmpItemKind", wrapper.comment)
	
	-- Set syntax highlighting
	vim.api.nvim_set_hl(0, "@variable", wrapper.var)
	vim.api.nvim_set_hl(0, "@variable.builtin", wrapper.reserved)
	vim.api.nvim_set_hl(0, "@variable.parameter", { link = "@variable" })
	vim.api.nvim_set_hl(0, "@variable.parameter.builtin", { link = "@variable" })
	
	vim.api.nvim_set_hl(0, "@constant", wrapper.var)
	vim.api.nvim_set_hl(0, "@constant.builtin", wrapper.reserved)
	vim.api.nvim_set_hl(0, "@constant.macro", wrapper.preprocessor)
	
	vim.api.nvim_set_hl(0, "@module", wrapper.type)
	vim.api.nvim_set_hl(0, "@module.builtin", { link = "@module" })
	vim.api.nvim_set_hl(0, "@label", wrapper.reserved)
	
	vim.api.nvim_set_hl(0, "@string", wrapper.string)
	vim.api.nvim_set_hl(0, "@string.documentation", { link = "@string" })
	vim.api.nvim_set_hl(0, "@string.regexp", { link = "@string" })
	vim.api.nvim_set_hl(0, "@string.escape", wrapper.escape)
	vim.api.nvim_set_hl(0, "@string.special", { link = "@string" })
	vim.api.nvim_set_hl(0, "@string.special.symbol", { link = "@string" })
	vim.api.nvim_set_hl(0, "@string.special.path", { link = "@string" })
	vim.api.nvim_set_hl(0, "@string.special.url", { link = "@string" })
	
	vim.api.nvim_set_hl(0, "@character", wrapper.string)
	vim.api.nvim_set_hl(0, "@character.special", { link = "@character" })
	
	vim.api.nvim_set_hl(0, "@boolean", wrapper.reserved)
	vim.api.nvim_set_hl(0, "@number", wrapper.number)
	vim.api.nvim_set_hl(0, "@number.float", { link = "@number" })
	
	vim.api.nvim_set_hl(0, "@type", wrapper.type)
	vim.api.nvim_set_hl(0, "@type.builtin", { link = "@type" })
	vim.api.nvim_set_hl(0, "@type.definition", { link = "@type" })
	
	vim.api.nvim_set_hl(0, "@attribute", wrapper.type)
	vim.api.nvim_set_hl(0, "@attribute.builtin", { link = "@attribute" })
	vim.api.nvim_set_hl(0, "@property", wrapper.var)
	
	vim.api.nvim_set_hl(0, "@function", wrapper.func)
	vim.api.nvim_set_hl(0, "@function.builtin", { link = "@function" })
	vim.api.nvim_set_hl(0, "@function.call", { link = "@function" })
	vim.api.nvim_set_hl(0, "@function.macro", wrapper.preprocessor)
	vim.api.nvim_set_hl(0, "@function.method", { link = "@function" })
	vim.api.nvim_set_hl(0, "@function.method.call", { link = "@function" })
	
	vim.api.nvim_set_hl(0, "@constructor", wrapper.func)
	
	vim.api.nvim_set_hl(0, "@operator", wrapper.operator)
	vim.api.nvim_set_hl(0, "@punctuation.delimiter", { link = "@operator" })
	vim.api.nvim_set_hl(0, "@punctuation.bracket", { link = "@operator" })
	vim.api.nvim_set_hl(0, "@punctuation.special", { link = "@operator" })
	
	vim.api.nvim_set_hl(0, "@keyword", wrapper.reserved)
	vim.api.nvim_set_hl(0, "@keyword.coroutine", { link = "@keyword" })
	vim.api.nvim_set_hl(0, "@keyword.function", { link = "@keyword" })
	vim.api.nvim_set_hl(0, "@keyword.operator", { link = "@keyword" })
	vim.api.nvim_set_hl(0, "@keyword.import", { link = "@keyword" })
	vim.api.nvim_set_hl(0, "@keyword.type", { link = "@keyword" })
	vim.api.nvim_set_hl(0, "@keyword.modifier", { link = "@keyword" })
	vim.api.nvim_set_hl(0, "@keyword.repeat", { link = "@keyword" })
	vim.api.nvim_set_hl(0, "@keyword.return", { link = "@keyword" })
	vim.api.nvim_set_hl(0, "@keyword.debug", { link = "@keyword" })
	vim.api.nvim_set_hl(0, "@keyword.exception", { link = "@keyword" })
	vim.api.nvim_set_hl(0, "@keyword.conditional", { link = "@keyword" })
	vim.api.nvim_set_hl(0, "@keyword.conditional.ternary", wrapper.operator)
	
	vim.api.nvim_set_hl(0, "@keyword.directive", wrapper.preprocessor)
	vim.api.nvim_set_hl(0, "@keyword.directive.define", wrapper.preprocessor)
	
	vim.api.nvim_set_hl(0, "@comment", wrapper.comment)
	vim.api.nvim_set_hl(0, "@comment.documentation", { link = "@comment" })
	
	-- fix lua highlighting
	vim.api.nvim_set_hl(0, "@constructor.lua", wrapper.operator)
	
	-- fix cpp highlighting
	vim.api.nvim_set_hl(0, "@keyword.import.c", wrapper.preprocessor)
	vim.api.nvim_set_hl(0, "@keyword.import.cpp", wrapper.preprocessor)

end

-- Create user command to change the color of a specific syntax group
vim.api.nvim_create_user_command("Color", function(opts)
	local args = opts.fargs

	if #args == 0 then -- Print all current colors
		local lines = {}
		for group, color in pairs(colors) do
			table.insert(lines, group .. ": " .. color)
		end
		print(table.concat(lines, "\n"))
	elseif #args == 1 then -- Print the color of the given group
		local group = args[1]
		if not colors[group] then
			vim.notify("Error: '" .. group .. "' is not a valid syntax group", vim.log.levels.ERROR)
			return
		end
		print(colors[group])
	else -- Change the color of the given group
		local group = args[1]
		local color = args[2]
		if not colors[group] then
			vim.notify("Error: '" .. group .. "' is not a valid syntax group", vim.log.levels.ERROR)
			return
		end
		if not color:find("^#%x%x%x%x%x%x$") then
			vim.notify("Error: '" .. color .. "' is not a valid hex color", vim.log.levels.ERROR)
			return
		end
		-- Assign color to group and apply
		colors[group] = color
		apply_colors()
	end
end, { nargs = "*" })

-- Disable legacy regex highlighting globally
vim.cmd("syntax off")

-- Execute function to apply colors at startup
apply_colors()

