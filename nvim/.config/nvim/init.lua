-- inspired by https://tkg.codes/guide-to-modern-neovim-setup-2021/
--
-- GENERAL SETTINGS
-- Dependencies

-- Load lazy.nvim plugin manager (replaces Packer)
require("config.lazy")

require("keybindings")

-- LSP & Completion (Native Neovim LSP)
require("config.lsp")  -- LSP server configurations and keybindings
require("config.cmp")  -- nvim-cmp completion setup

-- Plugin configs are now managed by lazy.nvim in lua/plugins/init.lua

-- Make sure Tiltfile is recognized
vim.api.nvim_create_autocmd({"BufRead"}, {
  pattern = {"Tiltfile"},
  command = "set filetype=tiltfile",
})


-- Incremental live completion
vim.o.inccommand = 'nosplit'

-- Set highlight on search. This will remove the highlight after searching for text.
vim.o.hlsearch = false

-- Make relative line numbers default. The current line number will be shown as well as relative numbering from that current line. It makes navigating around code easier.
vim.wo.number = true
vim.wo.relativenumber = true

-- Do not save when switching buffers
vim.o.hidden = true

-- Enable break indent.
vim.o.breakindent = true

-- Save undo history.
vim.opt.undofile = true

-- Case insensitive searching unless /C or capital in search.
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time.
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme defaults (order is important here).
vim.o.termguicolors = true

-- mode already in lualine
vim.opt.showmode = false

-- Highlight on yank (copy). It will do a nice highlight blink of the thing you just copied.
vim.api.nvim_exec(
  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
  false
)

-- Y yank until the end of line (consistent with D and C behavior)
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })

-- Set dark theme if macOS theme is dark, light otherwise.
local theme = vim.fn.system("defaults read -g AppleInterfaceStyle")
if (string.find(theme, 'Dark')) then
	vim.o.background = 'dark'
	vim.cmd [[colorscheme catppuccin-mocha]]
else
	vim.o.background = 'light'
	vim.cmd [[colorscheme catppuccin-latte]]
end
