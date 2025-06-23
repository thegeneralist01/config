--[[
These three tabs are necessary when dealing with this nonsense:
- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md#arguments
- https://github.com/jay-babu/mason-null-ls.nvim
- https://github.com/nvimtools/none-ls.nvim
--]]
return {
	"jay-babu/mason-null-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"nvimtools/none-ls.nvim",
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		require("mason-null-ls").setup({
			ensure_installed = {
				"stylua",
				"jq",
				"mypy",
				"ruff",
				"black",
			},
			handlers = {
				["mypy"] = function(source_name, methods)
					local options = {
						extra_args = function()
							local command = "which python"
							local handle = io.popen(command)
              local python_path = ""
              if handle then
                python_path = handle:read("*a")
                python_path = string.gsub(python_path, "\n", "")
                handle:close()
              end
							return { "--python-executable", python_path }
						end,
					}
					null_ls.register(null_ls.builtins.diagnostics.mypy.with(options))
				end,
				--[[ ["ruff"] = function(source_name, methods)
          null_ls.register(null_ls.builtins.diagnostics.ruff)
          --require('mason-null-ls').default_setup(source_name, methods) -- to maintain default behavior
        end, ]]
			},
		})

		null_ls.setup()
	end,
}
