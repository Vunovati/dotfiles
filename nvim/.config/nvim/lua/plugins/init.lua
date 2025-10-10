-- Lazy.nvim plugin specifications
-- Converted from Packer format with lazy-loading optimizations

return {
  -- Core utilities (loaded on startup - lightweight)
  'tpope/vim-commentary',
  'tpope/vim-surround',
  'tpope/vim-repeat',
  'tpope/vim-unimpaired',
  'tpope/vim-sleuth',

  -- Git plugins (lazy-load on Git commands)
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'Gstatus', 'Gblame', 'Gpush', 'Gpull' },
    keys = {
      { '<leader>g', ':Git<cr>', desc = 'Open Git' },
      { '<leader>gb', ':Git blame<cr>', desc = 'Git blame' },
    },
  },
  {
    'tpope/vim-rhubarb',
    dependencies = { 'tpope/vim-fugitive' },
  },
  {
    'shumphrey/fugitive-gitlab.vim',
    dependencies = { 'tpope/vim-fugitive' },
  },

  -- Copilot (commented out, can enable if needed)
  -- 'github/copilot.vim',

  -- Telescope - fuzzy finder (lazy-load on keys)
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<C-n>', '<cmd>lua require("telescope.builtin").find_files({previewer = false})<cr>', desc = 'Find files' },
      { '<C-p>', '<cmd>lua require("telescope.builtin").oldfiles()<cr>', desc = 'Recent files' },
      { '<leader>sb', '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<cr>', desc = 'Search buffer' },
      { '<leader>sh', '<cmd>lua require("telescope.builtin").help_tags()<cr>', desc = 'Search help' },
      { '<leader>st', '<cmd>lua require("telescope.builtin").tags()<cr>', desc = 'Search tags' },
      { '<leader>sd', '<cmd>lua require("telescope.builtin").grep_string()<cr>', desc = 'Grep string' },
      { '<leader>sp', '<cmd>lua require("telescope.builtin").live_grep({ default_text = vim.fn.expand("<cword>") })<cr>', desc = 'Live grep' },
      { '<leader>so', '<cmd>lua require("telescope.builtin").tags{ only_current_buffer = true }<cr>', desc = 'Buffer tags' },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
              ['<C-j>'] = "move_selection_next",
              ['<C-k>'] = "move_selection_previous",
              ["<C-h>"] = "which_key"
            },
          },
        },
      }
    end,
  },

  -- Ripgrep integration (lazy-load on command)
  {
    'jremmen/vim-ripgrep',
    cmd = 'Rg',
  },

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
    config = function()
      require('lualine').setup({
        options = {
          theme = 'catppuccin'
        }
      })
    end,
  },

  -- Git signs
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    lazy = false,
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
      }
    end,
  },

  -- Treesitter - syntax highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = 'gnn',
            node_incremental = 'grn',
            scope_incremental = 'grc',
            node_decremental = 'grm',
          },
        },
        indent = {
          enable = true,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
        },
      }
      vim.treesitter.language.register('starlark', 'tiltfile')
    end,
  },

  -- Treesitter textobjects
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },

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

  -- Formatter (lazy-load on command/keys)
  {
    'mhartington/formatter.nvim',
    cmd = { 'Format', 'FormatWrite' },
    keys = {
      { '<leader>t', ':Format<CR>', desc = 'Format file' },
      { '<leader>F', ':FormatWrite<CR>', desc = 'Format and write' },
    },
    config = function()
      local function format_prettier()
        return {
          exe = "npx",
          args = {"prettier", "--stdin-filepath", vim.api.nvim_buf_get_name(0)},
          stdin = true
        }
      end

      require('formatter').setup {
        logging = true,
        log_level = vim.log.levels.WARN,
        filetype = {
          typescript = { format_prettier },
          typescriptreact = { format_prettier },
          javascript = { format_prettier },
          javascriptreact = { format_prettier },
          json = { format_prettier },
          yaml = { format_prettier }
        }
      }
    end,
  },

  -- React extract (lazy-load on command)
  {
    'napmn/react-extract.nvim',
    cmd = { 'ReactExtract', 'ReactExtractToFile' },
  },

  -- Git linker (lazy-load on keys)
  {
    'ruifm/gitlinker.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>gy', mode = { 'n', 'v' }, desc = 'Copy git link' },
    },
    config = function()
      require"gitlinker".setup({
        opts = {
          remote = nil,
          add_current_line_on_normal_mode = true,
          action_callback = require"gitlinker.actions".copy_to_clipboard,
          print_url = true,
        },
        callbacks = {
          ["github.com"] = require"gitlinker.hosts".get_github_type_url,
          ["gitlab.com"] = require"gitlinker.hosts".get_gitlab_type_url,
          ["try.gitea.io"] = require"gitlinker.hosts".get_gitea_type_url,
          ["codeberg.org"] = require"gitlinker.hosts".get_gitea_type_url,
          ["bitbucket.org"] = require"gitlinker.hosts".get_bitbucket_type_url,
          ["try.gogs.io"] = require"gitlinker.hosts".get_gogs_type_url,
          ["git.sr.ht"] = require"gitlinker.hosts".get_srht_type_url,
          ["git.launchpad.net"] = require"gitlinker.hosts".get_launchpad_type_url,
          ["repo.or.cz"] = require"gitlinker.hosts".get_repoorcz_type_url,
          ["git.kernel.org"] = require"gitlinker.hosts".get_cgit_type_url,
          ["git.savannah.gnu.org"] = require"gitlinker.hosts".get_cgit_type_url
        },
        mappings = "<leader>gy"
      })
    end,
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

  -- Terminal (lazy-load on keys)
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    keys = {
      { '<C-\\>', mode = { 'n', 'i', 't' }, desc = 'Toggle terminal' },
    },
    config = function()
      require("toggleterm").setup({
        direction = 'vertical',
        size = 35,
        open_mapping = [[<C-\>]],
        insert_mappings = true,
      })

      function _G.set_terminal_keymaps()
        local opts = {buffer = 0}
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
      end

      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end,
  },

  -- Rainbow delimiters (load at startup for syntax highlighting)
  {
    'HiPhish/rainbow-delimiters.nvim',
    lazy = false,
    config = function()
      local rainbow_delimiters = require 'rainbow-delimiters'
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        priority = {
          [''] = 110,
          lua = 210,
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      }
    end,
  },

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
