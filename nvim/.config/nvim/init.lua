-- inspired by https://tkg.codes/guide-to-modern-neovim-setup-2021/
--
-- GENERAL SETTINGS
-- Dependencies
require("plugins")
require("keybindings")
require("lsp")

-- Plugin specific configs.
require("plugs.treesitter")
require("plugs.cmp")
require("plugs.telescope")
require("plugs.gitsigns")
require("plugs.null-ls")
require("plugs.formatter")
require("plugs.react-extract")
require("plugs.gitlinker")

-- Incremental live completion (note: this is now a default on master).
vim.o.inccommand = 'nosplit'

-- Set highlight on search. This will remove the highlight after searching for text.
vim.o.hlsearch = false

-- Make relative line numbers default. The current line number will be shown as well as relative numbering from that current line. It makes navigating around code easier.
vim.wo.number = true
vim.wo.relativenumber = true

-- Do not save when switching buffers (note: default on master).
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
-- vim.g.onedark_terminal_italics = 2
-- vim.o.background = 'light'
-- vim.cmd [[colorscheme PaperColor]]

-- Set status bar settings
-- vim.g.lightline = {
--   colorscheme = 'PaperColor',
--   active = { left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'filename', 'modified' } } },
--   component_function = { gitbranch = 'FugitiveHead' },
-- }

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

-- Y yank until the end of line  (note: this is now a default on master)
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })

-- Set dark theme if macOS theme is dark, light otherwise.
local theme = vim.fn.system("defaults read -g AppleInterfaceStyle")
if (string.find(theme, 'Dark')) then
	vim.o.background = 'dark'
	vim.cmd [[colorscheme catppuccin-mocha]]
else
	vim.o.background = 'light'
	vim.cmd [[colorscheme catppuccin-latte]]
	-- vim.cmd [[colorscheme PaperColor]]
end


-- vim.api.nvim_set_keymap('n', '<leader>mm', [[<Cmd>lua require('material.functions').toggle_style()<CR>]], { noremap = true, silent = true })
