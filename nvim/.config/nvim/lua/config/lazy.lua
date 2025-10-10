-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Leader key should be set before loading lazy.nvim
-- Currently using default leader key '\' (backslash)
-- If you want to change it, uncomment and modify:
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
-- Load plugin specs
local plugin_specs = require("plugins")

require("lazy").setup({
  spec = plugin_specs,
  -- Install colorscheme used during installation
  install = { colorscheme = { "catppuccin" } },
  -- Automatically check for plugin updates
  checker = { enabled = false }, -- Can enable after migration is stable
  -- UI settings
  ui = {
    border = "rounded",
  },
})
