-- PLUGINS

-- Install packer. You don't have to necessarily understand this code. Just know that it will grab packer from the Internet and install it for you.
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.api.nvim_exec(
  [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]],
  false
)

-- Here we can declare the plugins we'll be using.
local use = require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Package manager itself.
  use 'tpope/vim-fugitive' -- Git commands for nvim.
  use 'tpope/vim-commentary' -- Use "gc" to comment lines in visual mode. Similarly to cmd+/ in other editors.
  use 'tpope/vim-surround' -- A great tool for adding, removing and changing braces, brackets, quotes and various tags around your text.
  use 'tpope/vim-repeat'
  use 'tpope/vim-rhubarb'
  use 'shumphrey/fugitive-gitlab.vim'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-sleuth'
  use 'github/copilot.vim'
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } } -- UI to select things (files, search results, open buffers...)
  use 'jremmen/vim-ripgrep'
  use 'kyazdani42/nvim-web-devicons'
  use { 'romgrk/barbar.nvim', requires = {'kyazdani42/nvim-web-devicons'} } -- A bar that will show at the top of you nvim containing your open buffers. Similarly to how other editors show tabs with open files.
  use { 'nvim-lualine/lualine.nvim', requires = { 'kyadzani42/nvim-web-devicons', opt = true } }
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } } -- Adds git related info in the signs columns (near the line numbers) and popups.
  use 'nvim-treesitter/nvim-treesitter' -- Highlight, edit, and navigate code using a fast incremental parsing library. Treesitter is used by nvim for various things, but among others, for syntax coloring. Make sure that any themes you install support treesitter!
  use 'nvim-treesitter/nvim-treesitter-textobjects' -- Additional textobjects for treesitter.
  use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client.
  use 'williamboman/nvim-lsp-installer'
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin.
  use 'hrsh7th/cmp-nvim-lsp'
  -- use 'jose-elias-alvarez/null-ls.nvim'
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip' -- Snippets plugin.
  use 'folke/which-key.nvim'
  use 'mhartington/formatter.nvim'
  use 'napmn/react-extract.nvim'
  use { 'ruifm/gitlinker.nvim', requires = 'nvim-lua/plenary.nvim' }
  use { "catppuccin/nvim", as = "catppuccin" }
  use ('Tsuzat/NeoSolarized.nvim')
  use { 'folke/tokyonight.nvim' }
  use { 'sainnhe/everforest' }
  use {'akinsho/toggleterm.nvim', tag = '*' }
  use 'HiPhish/rainbow-delimiters.nvim' 
end)

-- luasnip setup (you can leave this here or move it to its own configuration file in `lua/plugs/luasnip.lua`.)
luasnip = require 'luasnip'
