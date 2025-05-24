return {
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "1.*",
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = "default" },

      appearance = {
        nerd_font_variant = "mono",
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = { documentation = { auto_show = true } },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },

  -- {
  --   'neovim/nvim-lspconfig',
  --   dependencies = {
  --     'saghen/blink.cmp',
  -- 	'williamboman/mason.nvim',
  -- 	'mason-org/mason-registry',
  -- 	'williamboman/mason-lspconfig.nvim',
  -- 	'L3MON4D3/LuaSnip',
  -- 	'saadparwaiz1/cmp_luasnip',
  -- 	'j-hui/fidget.nvim',
  --   },
  --
  --   -- example using `opts` for defining servers
  --   opts = {
  --     servers = {
  --       lua_ls = {}
  --     }
  --   },
  --   config = function(_, opts)
  -- 	require("fidget").setup({})
  -- 	require("mason").setup()
  --
  --     local lspconfig = require('mason-lspconfig')
  --     for server, config in pairs(opts.servers) do
  --       -- passing config.capabilities to blink.cmp merges with the capabilities in your
  --       -- `opts[server].capabilities, if you've defined it
  --       print('configuring server:', server)
  --       config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
  --       require("lspconfig")[server].setup(config)
  --     end
  --   end
  --
  -- example calling setup directly for each LSP
  -- config = function()
  --   local capabilities = require('blink.cmp').get_lsp_capabilities()
  --   local lspconfig = require('lspconfig')
  --
  --   lspconfig['lua_ls'].setup({ capabilities = capabilities })
  -- end
  -- },
}
