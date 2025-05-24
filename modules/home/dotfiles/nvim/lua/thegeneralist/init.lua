require("thegeneralist.remap")
require("thegeneralist.set")
require("thegeneralist.lazy_init")


local augroup = vim.api.nvim_create_augroup
local thegeneralist_group = augroup('thegeneralist', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

autocmd('TextYankPost', {
  group = yank_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

autocmd({ "BufWritePre" }, {
  group = thegeneralist_group,
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

autocmd('LspAttach', {
  group = thegeneralist_group,
  callback = function(e)
    -- @param desc string
    local function opts(desc)
      return {
        buffer = e.buf,
        --noremap = true, -- Not sure about this
        desc = "[LSP] " .. desc
      }
    end

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts("Go to Definition"))
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to Declaration"))
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts("Hover info"))
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts("Workspace Symbol"))
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts("Open float?"))
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts("View code actions"))
    vim.keymap.set("i", "<C-]>", function() vim.lsp.buf.code_action() end, opts("View code actions"))
    vim.keymap.set("n", "<leader>va", function()
        -- TODO: this
        local params = vim.lsp.util.make_range_params()
        params.context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
        local result, err = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
        if result and result[1] and result[1].result and result[1].result[1] then
            local first_action = result[1].result[1]
            vim.lsp.buf.execute_command(first_action.command)
        else
            print("No code actions available")
        end
    end, opts("Apply 1st code action"))
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts("Show references"))
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts("Rename"))
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({
        count = 1,
        float = true,
      })
    end, opts("Previous diagnostic"))
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({
        count = -1,
        float = true,
      })
    end, opts("Next diagnostic"))
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts("Signature help"))
    vim.keymap.set("n", "<leader>h", function() vim.lsp.buf.signature_help() end, opts("Signature help"))
  end
})
