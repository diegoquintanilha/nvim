-- Tables for each theme's color schemes and syntax highlight groups
local themes = {
	red_sunset = {
		pretty_name = "Red Sunset",
		
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
		line         = "#707070", -- Gray (same as comment)
	},
	gruber_darker = {
		pretty_name = "Gruber Darker",
		-- Background colors
		background     = "#161616", -- Dark gray
		highlight      = "#484848", -- Gray
		search         = "#400070", -- Purple
		completion_box = "#011B41", -- Dark blue
		fold           = "#00D0D0", -- Cyan

		-- Syntax highlighting colors
		var          = "#EEEEEE", -- Light gray
		func         = "#B0B0D0", -- Blue gray
		type         = "#0077FF", -- Blue
		reserved     = "#FF0000", -- Red
		operator     = "#DDDD00", -- Yellow
		string       = "#60B030", -- Green
		escape       = "#008030", -- Dark green
		number       = "#00FF00", -- Light green
		preprocessor = "#FF00FF", -- Magenta
		comment      = "#CC8C3C", -- Brown
		line         = "#484848", -- Gray (same as highlight)
	},
	luna = {
		pretty_name = "Luna",
		-- Background colors
		background     = "#060606", -- Dark gray
		highlight      = "#212121", -- Gray
		search         = "#400070", -- Purple
		completion_box = "#011B41", -- Dark blue
		fold           = "#33AACC", -- Cyan

		-- Syntax highlighting colors
		var          = "#C7C7C7", -- Light gray
		func         = "#75C1C7", -- Light blue
		type         = "#C4A8D6", -- Light purple
		reserved     = "#E19067", -- Orange
		operator     = "#C7C7C7", -- Light gray (same as var)
		string       = "#9EB38E", -- Green
		escape       = "#608050", -- Dark green
		number       = "#00E000", -- Light green
		preprocessor = "#DD00DD", -- Magenta
		comment      = "#7C7C7C", -- Gray
		line         = "#7C7C7C", -- Light gray (same as comment)
	},
}

-- Select theme
local current_theme = themes.red_sunset

-- Get all colors in the table and apply them for their specific groups
local function apply_colors(theme)
	-- Create wrapper table using the global colors
	local wrapper = {
		background     = { bg = theme.background },
		highlight      = { bg = theme.highlight },
		search         = { bg = theme.search },
		completion_box = { bg = theme.completion_box },
		fold           = { fg = theme.fold,         bold = true,  italic = false, nocombine = true },
		var            = { fg = theme.var,          bold = false, italic = false, nocombine = true },
		func           = { fg = theme.func,         bold = false, italic = false, nocombine = true },
		type           = { fg = theme.type,         bold = true,  italic = false, nocombine = true },
		reserved       = { fg = theme.reserved,     bold = false, italic = true , nocombine = true },
		operator       = { fg = theme.operator,     bold = false, italic = false, nocombine = true },
		string         = { fg = theme.string,       bold = false, italic = false, nocombine = true },
		escape         = { fg = theme.escape,       bold = false, italic = false, nocombine = true },
		number         = { fg = theme.number,       bold = false, italic = false, nocombine = true },
		preprocessor   = { fg = theme.preprocessor, bold = false, italic = false, nocombine = true },
		comment        = { fg = theme.comment,      bold = false, italic = false, nocombine = true },
		line           = { fg = theme.line,         bold = false, italic = false, nocombine = true },
	}
	
	-- Set editor window colors
	vim.api.nvim_set_hl(0, "Normal", wrapper.background)
	vim.api.nvim_set_hl(0, "Visual", wrapper.highlight)
	vim.api.nvim_set_hl(0, "StatusLine", wrapper.highlight)
	vim.opt.laststatus = 3 -- Fix a single status bar
	
	vim.api.nvim_set_hl(0, "WinSeparator", wrapper.line)
	vim.api.nvim_set_hl(0, "IblIndent", wrapper.line)
	
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

	if #args == 0 then
		-- Print all current colors
		local lines = {}
		table.insert(lines, "Theme: " .. current_theme.pretty_name .. "\n")
		for group, color in pairs(current_theme) do
			table.insert(lines, group .. ": " .. color)
		end
		print(table.concat(lines, "\n"))
	elseif #args == 1 then
		local arg = args[1]
		if themes[arg] ~= nil then
			-- Change to the given theme
			current_theme = themes[arg]
			apply_colors(current_theme)
			print("Changed theme to " .. current_theme.pretty_name)
		elseif current_theme[arg] ~= nil then
			-- Print the color of the given group
			print(current_theme[arg])
		else
			vim.notify("Error: '" .. arg .. "' is not a valid theme nor syntax group", vim.log.levels.ERROR)
			return
		end
	else
		-- Change the color of the given group
		local group = args[1]
		local color = args[2]
		if not current_theme[group] then
			vim.notify("Error: '" .. group .. "' is not a valid syntax group", vim.log.levels.ERROR)
			return
		end
		if not color:find("^#%x%x%x%x%x%x$") then
			vim.notify("Error: '" .. color .. "' is not a valid hex color", vim.log.levels.ERROR)
			return
		end
		-- Assign color to group and apply
		current_theme[group] = color
		apply_colors(current_theme)
	end
end, { nargs = "*" })

-- Disable legacy regex highlighting globally
vim.cmd("syntax off")

-- Execute function to apply the selected theme colors at startup
apply_colors(current_theme)

