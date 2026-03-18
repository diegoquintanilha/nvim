return {
	"ibhagwan/fzf-lua",
	-- For icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- Lazy load the plugin
	cmd = "FzfLua",
	-- Set keymaps
	keys = {
		{ "<LEADER>ff", "<CMD>FzfLua files<CR>" },
		{ "<LEADER>fb", "<CMD>FzfLua buffers<CR>" },
		{ "<LEADER>fr", "<CMD>FzfLua oldfiles<CR>" },
		{ "<LEADER>fh", "<CMD>FzfLua help_tags<CR>" },
	},
}

