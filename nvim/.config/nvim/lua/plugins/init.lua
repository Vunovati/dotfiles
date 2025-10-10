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

  -- ============================================================================
  -- LSP & COMPLETION STACK (Native Neovim LSP replacing CoC)
  -- ============================================================================

  -- Mason: Package manager for LSP servers, formatters, linters, DAP servers
  -- Central hub for installing and managing all development tools
  -- UI: :Mason to browse and install tools
  {
    'williamboman/mason.nvim',
    lazy = false, -- Load immediately to ensure tools are available
    priority = 800, -- Load before LSP servers
    config = function()
      require('mason').setup({
        ui = {
          border = 'rounded',
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },

  -- Mason-LSPConfig: Bridges mason.nvim with nvim-lspconfig
  -- Automatically sets up LSP servers installed via Mason
  -- OVERLAP: Also installs LSP servers (along with mason-tool-installer)
  -- but this one specifically handles LSP server configuration
  {
    'williamboman/mason-lspconfig.nvim',
    lazy = false,
    priority = 799, -- Load after mason, before lspconfig
    dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
    config = function()
      local lsp_config = require('config.lsp')
      require('mason-lspconfig').setup({
        -- Auto-install these LSP servers
        ensure_installed = {
          'ts_ls',     -- TypeScript/JavaScript (formerly tsserver)
          'lua_ls',       -- Lua
          'jsonls',       -- JSON
          'yamlls',       -- YAML
          'bashls',       -- Bash
        },
        automatic_installation = true,
        -- Handlers automatically set up LSP servers (Neovim 0.11+ compatible)
        handlers = {
          -- Default handler for all servers
          function(server_name)
            local server_config = lsp_config.server_configs[server_name] or {}
            require('lspconfig')[server_name].setup(vim.tbl_deep_extend('force', {
              on_attach = lsp_config.on_attach,
              capabilities = lsp_config.capabilities,
            }, server_config))
          end,
        },
      })
    end,
  },

  -- Mason-Tool-Installer: Auto-installs formatters, linters, etc on startup
  -- OVERLAP: mason-lspconfig also installs LSP servers, but this adds
  -- convenience for formatters/linters and ensures tools are installed on startup
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    lazy = false,
    priority = 798,
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-tool-installer').setup({
        ensure_installed = {
          'prettier',  -- Formatter for JS/TS/JSON/YAML/etc
          'stylua',    -- Lua formatter
        },
        auto_update = false,
        run_on_start = true,
      })
    end,
  },

  -- NvimLSPConfig: Quickstart configs for Neovim LSP
  -- Provides pre-configured settings for 100+ LSP servers
  -- Core plugin that connects Mason-installed servers to Neovim's LSP client
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    priority = 797,
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    -- Configuration is in lua/config/lsp.lua (loaded from init.lua)
  },

  -- nvim-cmp: Completion engine
  -- Core completion plugin - everything else plugs into this
  -- Replaces CoC's completion functionality
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter', -- Lazy-load when entering insert mode
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',    -- LSP completion source
      'hrsh7th/cmp-buffer',      -- Buffer words completion
      'hrsh7th/cmp-path',        -- File path completion
      'L3MON4D3/LuaSnip',        -- Snippet engine
      'saadparwaiz1/cmp_luasnip', -- Snippet completion
      'rafamadriz/friendly-snippets', -- Pre-made snippets
    },
    -- Configuration is in lua/config/cmp.lua (loaded from init.lua)
  },

  -- cmp-nvim-lsp: LSP completion source for nvim-cmp
  -- Provides completions from LSP servers (function names, variables, etc)
  { 'hrsh7th/cmp-nvim-lsp', lazy = true },

  -- cmp-buffer: Buffer word completion
  -- OVERLAP: LSP also suggests words from buffer, but this is smarter about
  -- finding words across all buffers and handles non-LSP files better
  { 'hrsh7th/cmp-buffer', lazy = true },

  -- cmp-path: File path completion
  -- OVERLAP: Some LSP servers provide path completion, but this is more
  -- reliable and works in all contexts (strings, comments, etc)
  { 'hrsh7th/cmp-path', lazy = true },

  -- LuaSnip: Snippet engine
  -- Fast snippet engine written in Lua
  -- Supports VSCode-style snippets from friendly-snippets
  {
    'L3MON4D3/LuaSnip',
    lazy = true,
    version = 'v2.*',
    build = 'make install_jsregexp', -- Optional: for regex support
    dependencies = { 'rafamadriz/friendly-snippets' },
  },

  -- cmp_luasnip: Connect LuaSnip to nvim-cmp
  -- Makes snippets available in completion menu
  { 'saadparwaiz1/cmp_luasnip', lazy = true },

  -- friendly-snippets: Collection of pre-made snippets
  -- Provides snippets for many languages (JS/TS, Python, Go, etc)
  { 'rafamadriz/friendly-snippets', lazy = true },

  -- conform.nvim: Async formatter
  -- Modern replacement for formatter.nvim and null-ls formatting
  -- OVERLAP: LSP servers can format via vim.lsp.buf.format(), but conform is:
  --   - Faster (async, doesn't block editor)
  --   - More flexible (can chain multiple formatters)
  --   - Works without LSP (standalone formatters like prettier)
  -- REPLACES: formatter.nvim (will be removed after testing)
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' }, -- Load before saving
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>F',
        function()
          require('conform').format({ async = true, lsp_fallback = true })
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          javascript = { 'prettier' },
          javascriptreact = { 'prettier' },
          typescript = { 'prettier' },
          typescriptreact = { 'prettier' },
          json = { 'prettier' },
          yaml = { 'prettier' },
          lua = { 'stylua' },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  -- trouble.nvim: Pretty diagnostics, references, quickfix list
  -- Beautiful UI for viewing diagnostics, LSP references, etc
  -- OVERLAP: Telescope can show diagnostics, but Trouble is purpose-built for:
  --   - Better grouping by file/severity
  --   - Persistent diagnostics window
  --   - Replaces CoC's :CocList diagnostics
  {
    'folke/trouble.nvim',
    cmd = { 'Trouble', 'TroubleToggle' },
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('trouble').setup({})
    end,
  },

  -- lsp-signature.nvim: Show function signature while typing
  -- Automatically displays function signature with parameter hints
  -- OVERLAP: LSP has built-in signature help (vim.lsp.buf.signature_help),
  -- but this makes it automatic and prettier (no need to press a key)
  {
    'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
    config = function()
      require('lsp_signature').setup({
        bind = true,
        handler_opts = {
          border = 'rounded'
        },
        hint_enable = false, -- Disable virtual text hints (can be noisy)
      })
    end,
  },

  -- fidget.nvim: LSP progress notifications
  -- Shows LSP server status in bottom-right (e.g., "Indexing... 50%")
  -- Pure UI enhancement, no functional overlap with other plugins
  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },

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

  -- TypeScript tools (commented out - using native LSP instead)
  -- {
  --   "pmizio/typescript-tools.nvim",
  --   dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  --   config = function()
  --     require("typescript-tools").setup {}
  --   end,
  -- },

  -- ============================================================================
  -- CoC.nvim - DISABLED (Replaced by native LSP + Mason)
  -- Keeping commented for easy rollback if needed
  -- ============================================================================
  -- {
  --   'neoclide/coc.nvim',
  --   branch = 'release',
  --   lazy = false,
  --   priority = 900,
  -- },
}
