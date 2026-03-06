-- Disable legacy regex highlighting globally
vim.cmd("syntax off")

-- Background colors
color_background = { bg = "#090303" } -- Dark red
color_highlight = { bg = "#3A0707" } -- Red
color_search = { bg = "#400070" } -- Purple
color_fold = { fg = "#00D0D0", bold = true, italic = true } -- Cyan

-- Syntax highlighting colors
color_var = { fg = "#DDDDDD" } -- Light gray
color_func = { fg = "#FF6020" } -- Orange
color_type = { fg = "#005EFF", bold = true } -- Blue
color_reserved = { fg = "#FF0000", italic = true } -- Red
color_operator = { fg = "#DDDD00" } -- Yellow
color_string = { fg = "#40A040" } -- Green
color_escape = { fg = "#004030" } -- Dark green
color_number = { fg = "#00FF00" } -- Light green
color_preprocessor = { fg = "#FF00FF" } -- Magenta
color_comment = { fg = "#707070" } -- Gray

-- Set editor window colors
vim.api.nvim_set_hl(0, "Normal", color_background)
vim.api.nvim_set_hl(0, "Visual", color_highlight)
vim.api.nvim_set_hl(0, "WinSeparator", color_comment)

vim.api.nvim_set_hl(0, "StatusLine", color_highlight)
vim.opt.laststatus = 3 -- Fix a single status bar

vim.api.nvim_set_hl(0, "Search", color_search)
vim.api.nvim_set_hl(0, "CurSearch", color_search)

vim.api.nvim_set_hl(0, "LineNr", color_var)
vim.api.nvim_set_hl(0, "Folded", color_fold)

-- Set syntax highlighting
vim.api.nvim_set_hl(0, "@variable", color_var)
vim.api.nvim_set_hl(0, "@variable.builtin", color_reserved)
vim.api.nvim_set_hl(0, "@variable.parameter", { link = "@variable" })
vim.api.nvim_set_hl(0, "@variable.parameter.builtin", { link = "@variable" })

vim.api.nvim_set_hl(0, "@constant", color_var)
vim.api.nvim_set_hl(0, "@constant.builtin", color_reserved)
vim.api.nvim_set_hl(0, "@constant.macro", color_preprocessor)

vim.api.nvim_set_hl(0, "@module", color_type)
vim.api.nvim_set_hl(0, "@module.builtin", { link = "@module" })
vim.api.nvim_set_hl(0, "@label", color_reserved)

vim.api.nvim_set_hl(0, "@string", color_string)
vim.api.nvim_set_hl(0, "@string.documentation", { link = "@string" })
vim.api.nvim_set_hl(0, "@string.regexp", { link = "@string" })
vim.api.nvim_set_hl(0, "@string.escape", color_escape)
vim.api.nvim_set_hl(0, "@string.special", { link = "@string" })
vim.api.nvim_set_hl(0, "@string.special.symbol", { link = "@string" })
vim.api.nvim_set_hl(0, "@string.special.path", { link = "@string" })
vim.api.nvim_set_hl(0, "@string.special.url", { link = "@string" })

vim.api.nvim_set_hl(0, "@character", color_string)
vim.api.nvim_set_hl(0, "@character.special", { link = "@character" })

vim.api.nvim_set_hl(0, "@boolean", color_reserved)
vim.api.nvim_set_hl(0, "@number", color_number)
vim.api.nvim_set_hl(0, "@number.float", { link = "@number" })

vim.api.nvim_set_hl(0, "@type", color_type)
vim.api.nvim_set_hl(0, "@type.builtin", { link = "@type" })
vim.api.nvim_set_hl(0, "@type.definition", { link = "@type" })

vim.api.nvim_set_hl(0, "@attribute", color_type)
vim.api.nvim_set_hl(0, "@attribute.builtin", { link = "@attribute" })
vim.api.nvim_set_hl(0, "@property", color_var)

vim.api.nvim_set_hl(0, "@function", color_func)
vim.api.nvim_set_hl(0, "@function.builtin", { link = "@function" })
vim.api.nvim_set_hl(0, "@function.call", { link = "@function" })
vim.api.nvim_set_hl(0, "@function.macro", color_preprocessor)
vim.api.nvim_set_hl(0, "@function.method", { link = "@function" })
vim.api.nvim_set_hl(0, "@function.method.call", { link = "@function" })

vim.api.nvim_set_hl(0, "@constructor", color_func)

vim.api.nvim_set_hl(0, "@operator", color_operator)
vim.api.nvim_set_hl(0, "@punctuation.delimiter", { link = "@operator" })
vim.api.nvim_set_hl(0, "@punctuation.bracket", { link = "@operator" })
vim.api.nvim_set_hl(0, "@punctuation.special", { link = "@operator" })

vim.api.nvim_set_hl(0, "@keyword", color_reserved)
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
vim.api.nvim_set_hl(0, "@keyword.conditional.ternary", color_operator)

vim.api.nvim_set_hl(0, "@keyword.directive", color_preprocessor)
vim.api.nvim_set_hl(0, "@keyword.directive.define", color_preprocessor)

vim.api.nvim_set_hl(0, "@comment", color_comment)
vim.api.nvim_set_hl(0, "@comment.documentation", { link = "@comment" })

-- Fix lua highlighting
vim.api.nvim_set_hl(0, "@constructor.lua", color_operator)

-- Fix cpp highlighting
vim.api.nvim_set_hl(0, "@keyword.import.c", color_preprocessor)
vim.api.nvim_set_hl(0, "@keyword.import.cpp", color_preprocessor)

