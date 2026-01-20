return {
	"nvim-telescope/telescope.nvim",

	tag = "0.1.5",

	dependencies = {
		"nvim-lua/plenary.nvim",
	},

	config = function()
		require("telescope").setup({
			defaults = {
				preview = {
					treesitter = true,
				},
				file_ignore_patterns = {
					"node_modules",
				},
			},
		})
		local builtin = require("telescope.builtin")
		pcall(require("telescope").load_extension, "fzf")

		vim.keymap.set("n", "<leader>fs", function()
			local search_string = vim.fn.input("Grep > ")
			if search_string == "" then
				return
			end
			builtin.grep_string({ search = search_string })
		end)

		vim.keymap.set("n", "<leader>pws", function()
			local word = vim.fn.expand("<cword>")
			builtin.grep_string({ search = word })
		end)

		vim.keymap.set("n", "<leader>pWs", function()
			local word = vim.fn.expand("<cWORD>")
			builtin.grep_string({ search = word })
		end)

		vim.keymap.set("n", "<leader>fw", builtin.live_grep, {})



		vim.keymap.set("n", "<C-p>", builtin.git_files, {})

		vim.keymap.set("n", "<leader>pb", builtin.buffers, {})

		-- Slightly advanced example of overriding default behavior and theme
		vim.keymap.set("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })

		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", "<leader>on", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[O]pen [N]eovim files" })
	end,
}
