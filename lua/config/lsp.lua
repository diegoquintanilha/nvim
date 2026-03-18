local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Define clangd LSP config
-- Must have LLVM installed
vim.lsp.config("clangd", {
	cmd = { "clangd" },
	filetypes = { "c", "cpp" },
	root_markers = { ".git" },
	capabilities = capabilities,
})
vim.lsp.enable("clangd")

-- Define pylsp LSP config
-- pip install "python-lsp-server[all]"
vim.lsp.config("pylsp", {
	cmd = { "pylsp" },
	filetypes = { "python" },
	root_markers = { ".git" },
	capabilities = capabilities,
})
vim.lsp.enable("pylsp")

-- Define lua-language-server LSP config
-- github.com/LuaLS/lua-language-server
vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".git" },
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } }
		}
	}
})
vim.lsp.enable("lua_ls")

-- Set a limit of 5 autocomplete suggestions
vim.opt.pumheight = 5

-- Disable LSP diagnostics
vim.diagnostic.enable(false)

