-- inspired by https://tkg.codes/guide-to-modern-neovim-setup-2021/
--
-- GENERAL SETTINGS
-- Dependencies
require("plugins")
require("keybindings")
require("coc")
-- require("lsp")

-- Plugin specific configs.
require("plugs.treesitter")
-- require("plugs.cmp") -- using coc-nvim now
require("plugs.telescope")
require("plugs.gitsigns")
-- require("plugs.null-ls")
require("plugs.formatter")
require("plugs.react-extract")
require("plugs.gitlinker")
require("plugs.fugitive-gitlab")
require("plugs.lualine")
require("plugs.solarized")
require("plugs.toggleterm")
-- require("plugs.copilot")
require("plugs.rainbow-delimiters")
-- require("plugs.typescript-tools") -- using coc-nvim now

-- Make sure Tiltfile is recognized
vim.api.nvim_create_autocmd({"BufRead"}, {
  pattern = {"Tiltfile"},
  command = "set filetype=tiltfile",
})


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

-- Y yank until the end of line  (note: this is now a default on master)
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })

-- local ok_status, NeoSolarized = pcall(require, "NeoSolarized")
-- NeoSolarized.setup {
--   style = "light", -- "dark" or "light"
--   transparent = true, -- true/false; Enable this to disable setting the background color
--   terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
--   enable_italics = true, -- Italics for different hightlight groups (eg. Statement, Condition, Comment, Include, etc.)
--   styles = {
--     -- Style to be applied to different syntax groups
--     comments = { italic = true },
--     keywords = { italic = false },
-- 
--     variables = {},
--     string = { italic = false },
--     underline = true, -- true/false; for global underline
--     undercurl = true, -- true/false; for global undercurl
--   },
--   -- Add specific hightlight groups
--   on_highlights = function(highlights, colors) 
--     -- highlights.Include.fg = colors.red -- Using `red` foreground for Includes
--   end, 
-- }

-- Set dark theme if macOS theme is dark, light otherwise.
local theme = vim.fn.system("defaults read -g AppleInterfaceStyle")
if (string.find(theme, 'Dark')) then
	vim.o.background = 'dark'
	-- vim.cmd [[colorscheme NeoSolarized]]
	-- vim.cmd [[colorscheme everforest]]
	vim.cmd [[colorscheme catppuccin-mocha]]
else
	vim.o.background = 'light'
	-- vim.cmd [[colorscheme NeoSolarized]]
	-- vim.cmd [[colorscheme everforest]]
	vim.cmd [[colorscheme catppuccin-latte]]
	-- vim.cmd [[colorscheme PaperColor]]
end
