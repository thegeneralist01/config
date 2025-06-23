return {
  "theprimeagen/harpoon",
  branch = "harpoon2",
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup()

    -- Add and list
    vim.keymap.set(
      "n",
      "<leader>a",
      function() harpoon:list():add() end,
      { desc = '[Harpoon] Add file' }
    )
    vim.keymap.set(
      "n",
      "<C-e>",
      function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = '[Harpoon] Toggle quick menu' }
    )

    -- Navigate
    vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, { desc = '[Harpoon] First file' })
    vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end, { desc = '[Harpoon] Second file' })
    vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end, { desc = '[Harpoon] Third file' })
    vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end, { desc = '[Harpoon] Fourth file' })
    vim.keymap.set("n", "<C-]>", function()
      local input = vim.fn.input("File number > ")
      local file_number = tonumber(input, 10)
      if not file_number then return print(input .. " is not a valid number") end
      harpoon:list():select(file_number)
    end, { desc = '[Harpoon] File by number' })

    -- Set
    vim.keymap.set("n", "<leader><C-h>", function() harpoon:list():replace_at(1) end,
      { desc = '[Harpoon] Replace first file' })
    vim.keymap.set("n", "<leader><C-j>", function() harpoon:list():replace_at(2) end,
      { desc = '[Harpoon] Replace second file' })
    vim.keymap.set("n", "<leader><C-k>", function() harpoon:list():replace_at(3) end,
      { desc = '[Harpoon] Replace third file' })
    vim.keymap.set("n", "<leader><C-l>", function() harpoon:list():replace_at(4) end,
      { desc = '[Harpoon] Replace fourth file' })
    vim.keymap.set("n",
      "<leader><C-]>",
      function()
        local file_number = tonumber(vim.fn.input("File number > "), 10)
        if not file_number then return end
        harpoon:list():select(file_number)
      end,
      { desc = '[Harpoon] File by number' }
    )
  end
}
