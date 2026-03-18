return {
	"hrsh7th/nvim-cmp",
	dependencies = { "hrsh7th/cmp-nvim-lsp" },
	config = function()
		local cmp = require("cmp")
		local types = require("cmp.types")
		
		cmp.setup({
			enabled = function()
				-- Disable completion in comments
				if require("cmp.config.context").in_treesitter_capture("comment") then
					return false
				end
				return true
			end,
			snippet = {
				expand = function(args)
					vim.snippet.expand(args.body)
				end,
			},
			matching = {
				-- Only display completions that match the given text exactly
				disallow_fuzzy_matching = true,
				disallow_partial_matching = true,
				disallow_prefix_unmatching = true,
			},
			formatting = {
				fields = { "abbr", "kind" }, -- Display only the completion text and its kind (function, variable, etc)
				format = function(entry, vim_item)
					local max_width = 30 -- Max number of characters for completion text
					if #vim_item.abbr > max_width then
						vim_item.abbr = vim_item.abbr:sub(1, max_width - 1) .. "…"
					end
					return vim_item
				end,
			},
			mapping = {
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-k>"] = cmp.mapping.select_prev_item(),
			},
			sources = {{
				name = "nvim_lsp",
				entry_filter = function(entry)
					local kind = entry:get_kind()
					return kind ~= types.lsp.CompletionItemKind.Keyword
					   and kind ~= types.lsp.CompletionItemKind.Snippet
				end,
			}},
		})
	end,
}

