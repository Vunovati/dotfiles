-- KEYBINDINGS
-- Plugin specific keybindings are in the plugin's config files.

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Disable arrow keys
map('', '<up>', '<nop>')
map('', '<down>', '<nop>')
map('', '<left>', '<nop>')
map('', '<right>', '<nop>')

map('n', '<leader>g', ':Git<cr>')
map('n', '<leader>e', ':Explore<cr>')
map('n', '<leader>s', ':Sexplore<cr>')
map('n', '<leader>v', ':Vexplore<cr>')

map('n', '<leader>b', ':buffer  ')
map('n', '<leader>gb', ':Git blame<cr>')
map('n', '<leader>W', ':wa<cr>')
map('n', '<leader>w', ':w<cr>')

map('n', '<leader>f', ':Rg <C-R><C-W><CR>')

map('n', '<leader>F', ':FormatWrite<CR>')
