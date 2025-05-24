return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },
  --[[ {
    'boganworld/crackboard.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      session_key = 'redacted',
    },
  }, ]]
  {
    "onsails/lspkind-nvim",
  },
  -- {
  --   "ziglang/zig.vim",
  -- },
  {
    "nvim-lua/plenary.nvim",
    name = "plenary",
  },
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup()
    end,
  },
  -- {
  --   -- https://github.com/zbirenbaum/copilot.lua
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   config = function()
  --     require("copilot").setup({
  --       panel = {
  --         keymap = {
  --           jump_prev = "]]",
  --           jump_next = "[[",
  --           accept = "<Tab>",
  --           refresh = "gr",
  --           open = "<M-]>",
  --         },
  --       },
  --       suggestion = {
  --         auto_trigger = true,
  --         keymap = {
  --           accept = "<M-Tab>",
  --         },
  --       },
  --     })
  --     -- vim.keymap.set("n", "<leader>cpe", "<cmd>Copilot enable<CR>")
  --     -- vim.keymap.set("n", "<leader>cpd", "<cmd>Copilot disable<CR>")
  --   end,
  -- },
  {
    "github/copilot.vim",
    config = function()
      -- set <leader>cpd and <leader>cpe to disable/enable copilot
      vim.keymap.set("n", "<leader>cpe", "<cmd>Copilot enable<CR>")
      vim.keymap.set("n", "<leader>cpd", "<cmd>Copilot disable<CR>")
    end,
  },
  -- {
  --   "Exafunction/codeium.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "hrsh7th/nvim-cmp",
  --   },
  --   config = function()
  --     require("codeium").setup({
  --       -- https://github.com/Exafunction/codeium.vim
  --     })
  --   end
  -- },
  {
    "ldelossa/gh.nvim",
    dependencies = {
      "ldelossa/litee.nvim",
    },
  },
  "eandrju/cellular-automaton.nvim",
  "gpanders/editorconfig.nvim",

  -- Useful for getting pretty icons, but requires a Nerd Font.
  { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  "lambdalisue/nerdfont.vim",
  "junegunn/vim-easy-align",
  "rcarriga/nvim-notify",

  -- Highlight todo, notes, etc in comments
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
}
