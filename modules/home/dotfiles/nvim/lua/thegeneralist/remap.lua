vim.g.mapleader = " "
--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
--vim.keymap.set("n", "<leader>e", vim.cmd.Ex)
-- vim.keymap.set("n", "<leader>e", function()
--   vim.cmd("NvimTreeToggle")
-- end)

vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>vwm", function()
	require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
	require("vim-with-me").StopVimWithMe()
end)

vim.keymap.set("n", "<leader>vs", "<C-w>v")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<leader>m<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<leader>m<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>mk", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>mj", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>ge", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>")
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end)

vim.keymap.set("n", "zh", "$viBhzf", {
	desc = "Fold { block",
})

vim.keymap.set("n", "zj", "$vi[hzf", {
	desc = "Fold [ block",
})

vim.keymap.set("n", "zk", "$vibhzf", {
	desc = "Fold ( block",
})

vim.keymap.set("n", "ga", "<cmd>EasyAlign<CR>")
vim.keymap.set("v", "ga", "<cmd>'<,'>EasyAlign<CR>")

-- Keep selection in visual mode after indent
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Indent with tab
vim.keymap.set("v", "<Tab>", ">gv")
vim.keymap.set("v", "<S-Tab>", "<gv")

-- Close window on the bottom
vim.keymap.set("n", "<C-w>e", "<C-w>j<C-w>q")

vim.keymap.set("n", "<leader>w", function()
	vim.ui.input({ prompt = "Enter value for shiftwidth: " }, function(input)
		vim.o.shiftwidth = tonumber(input)
	end)
end)
-- vim.keymap.set("n", "<leader>tc", function()
-- 	-- local file_number = tonumber(vim.fn.input("File number > "), 10)
-- 	vim.fn.inputlist({
--     "Select a theme",
--     "1. onedark",
--   })
-- end)

vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<CR>", { desc = "Restart LSP" })
vim.keymap.set("n", "<leader>le", "<cmd>LspStart<CR>", { desc = "Start LSP" })
vim.keymap.set("n", "<leader>ld", "<cmd>LspStop<CR>", { desc = "Stop LSP" })
