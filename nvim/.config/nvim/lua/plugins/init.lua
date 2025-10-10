-- Lazy.nvim plugin specifications
-- Converted from Packer format

return {
  -- Core utilities
  'tpope/vim-fugitive',
  'tpope/vim-commentary',
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'tpope/vim-rhubarb',
  'shumphrey/fugitive-gitlab.vim',
  'tpope/vim-unimpaired',
  'tpope/vim-sleuth',

  -- Copilot (commented out, can enable if needed)
  -- 'github/copilot.vim',

  -- Telescope - fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Ripgrep integration
  'jremmen/vim-ripgrep',

  -- Icons (needed by many plugins, load at startup)
  {
    'kyazdani42/nvim-web-devicons',
    lazy = false,
  },

  -- Buffer bar
  {
    'romgrk/barbar.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    lazy = false,
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    lazy = false,
  },

  -- Git signs
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    lazy = false,
  },

  -- Treesitter - syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
  },

  -- Treesitter textobjects
  'nvim-treesitter/nvim-treesitter-textobjects',

  -- LSP config (available but not actively used - using CoC instead)
  'neovim/nvim-lspconfig',
  'williamboman/nvim-lsp-installer',

  -- Completion plugins (commented out - using CoC instead)
  -- 'hrsh7th/nvim-cmp',
  -- 'hrsh7th/cmp-nvim-lsp',
  -- 'jose-elias-alvarez/null-ls.nvim',
  -- 'saadparwaiz1/cmp_luasnip',
  -- 'L3MON4D3/LuaSnip',

  -- Which-key
  'folke/which-key.nvim',

  -- Formatter
  'mhartington/formatter.nvim',

  -- React extract
  'napmn/react-extract.nvim',

  -- Git linker
  {
    'ruifm/gitlinker.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- Colorschemes (load at startup for theme)
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000, -- Load before other plugins
  },

  {
    'Tsuzat/NeoSolarized.nvim',
    lazy = false,
  },

  {
    'folke/tokyonight.nvim',
    lazy = false,
  },

  {
    'sainnhe/everforest',
    lazy = false,
  },

  -- Terminal
  {
    'akinsho/toggleterm.nvim',
    version = '*',
  },

  -- Rainbow delimiters
  'HiPhish/rainbow-delimiters.nvim',

  -- TypeScript tools (commented out - using CoC instead)
  -- {
  --   "pmizio/typescript-tools.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   config = function()
  --     require("typescript-tools").setup {}
  --   end,
  -- },

  -- CoC.nvim - LSP and completion (must load at startup)
  {
    'neoclide/coc.nvim',
    branch = 'release',
    lazy = false,
    priority = 900, -- Load early but after colorscheme
  },
}
