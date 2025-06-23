return {
	"nvim-lualine/lualine.nvim",
	-- "freddiehaddad/feline.nvim",
	dependencies = {
		-- "Hitesh-Aggarwal/feline_one_monokai.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local tcolors = require("tokyonight.colors").setup() -- pass in any of the config options as explained above
		local util = require("tokyonight.util")
    local bgc = util.lighten(tcolors.bg_statusline, 0.9)

		local theme = {
			normal = {
				a = { fg = tcolors.fg, bg = bgc },
				b = { fg = tcolors.fg, bg = bgc },
				c = { fg = tcolors.fg, bg = bgc },
				z = { fg = tcolors.fg, bg = bgc },
			},
			insert = { a = { fg = tcolors.black, bg = tcolors.green } },
			visual = { a = { fg = tcolors.black, bg = tcolors.orange } },
			replace = { a = { fg = tcolors.black, bg = tcolors.green } },
		}

		local empty = require("lualine.component"):extend()
		function empty:draw(default_highlight)
			self.status = ""
			self.applied_separator = ""
			self:apply_highlights(default_highlight)
			self:apply_section_separators()
			return self.status
		end

		-- Put proper separators and gaps between components in sections
		local function process_sections(sections)
			for name, section in pairs(sections) do
				local left = name:sub(9, 10) < "x"
				for pos = 1, name ~= "lualine_z" and #section or #section - 1 do
					table.insert(section, pos * 2, { empty, color = { fg = tcolors.bg_dark, bg = tcolors.bg_dark } })
				end
				for id, comp in ipairs(section) do
					if type(comp) ~= "table" then
						comp = { comp }
						section[id] = comp
					end
					comp.separator = left and { right = "" } or { left = "" }
				end
			end
			return sections
		end

		local function search_result()
			if vim.v.hlsearch == 0 then
				return ""
			end
			local last_search = vim.fn.getreg("/")
			if not last_search or last_search == "" then
				return ""
			end
			local searchcount = vim.fn.searchcount({ maxcount = 9999 })
			return last_search .. "(" .. searchcount.current .. "/" .. searchcount.total .. ")"
		end

		local function modified()
			if vim.bo.modified then
				return "+"
			elseif vim.bo.modifiable == false or vim.bo.readonly == true then
				return "-"
			end
			return ""
		end

		require("lualine").setup({
			options = {
				theme = theme,
				component_separators = "",
				section_separators = { left = "", right = "" },
			},
			sections = process_sections({
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					-- "diff",
					{
						"diagnostics",
						source = { "nvim" },
						sections = { "error" },
						diagnostics_color = { error = { bg = tcolors.red1, fg = tcolors.bg } },
					},
					{
						"diagnostics",
						source = { "nvim" },
						sections = { "warn" },
						diagnostics_color = { warn = { bg = tcolors.orange, fg = tcolors.bg } },
					},
					{ "filename", file_status = false, path = 3 },
					{ modified, color = { bg = tcolors.red1, fg = "#ffffff" } },
					{
						"%w",
						cond = function()
							return vim.wo.previewwindow
						end,
					},
					{
						"%r",
						cond = function()
							return vim.bo.readonly
						end,
					},
					{
						"%q",
						cond = function()
							return vim.bo.buftype == "quickfix"
						end,
					},
				},
				lualine_c = {},
				lualine_x = {},
				lualine_y = { search_result, "filetype" },
				lualine_z = { "%l:%c", "%p%%/%L" },
			}),
			inactive_sections = {
				lualine_c = { "%f %y %m" },
				lualine_x = {},
			},
		})
	end,
}
