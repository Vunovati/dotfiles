-- ============================================================================
-- COMPLETION CONFIGURATION (nvim-cmp)
-- Replaces CoC's completion functionality
--
-- This file configures:
-- - nvim-cmp completion engine
-- - LuaSnip snippet engine
-- - Completion sources (LSP, buffer, path, snippets)
-- - Keybindings matching CoC exactly
-- - Completion menu appearance
-- ============================================================================

local cmp_ok, cmp = pcall(require, 'cmp')
if not cmp_ok then
  return
end

local luasnip_ok, luasnip = pcall(require, 'luasnip')
if not luasnip_ok then
  return
end

-- ============================================================================
-- LOAD SNIPPETS
-- friendly-snippets provides VSCode-style snippets for many languages
-- ============================================================================
require('luasnip.loaders.from_vscode').lazy_load()

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Check if there's text before cursor (for smart tab completion)
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

-- ============================================================================
-- COMPLETION MENU ICONS
-- Icons shown next to completion items indicating their source
-- ============================================================================
local kind_icons = {
  Text = '',
  Method = '󰆧',
  Function = '󰊕',
  Constructor = '',
  Field = '󰇽',
  Variable = '󰂡',
  Class = '󰠱',
  Interface = '',
  Module = '',
  Property = '󰜢',
  Unit = '',
  Value = '󰎠',
  Enum = '',
  Keyword = '󰌋',
  Snippet = '',
  Color = '󰏘',
  File = '󰈙',
  Reference = '',
  Folder = '󰉋',
  EnumMember = '',
  Constant = '󰏿',
  Struct = '',
  Event = '',
  Operator = '󰆕',
  TypeParameter = '󰅲',
}

-- ============================================================================
-- NVIM-CMP SETUP
-- ============================================================================
cmp.setup({
  -- ========================
  -- Snippet Engine
  -- ========================
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  -- ========================
  -- Completion Window Style
  -- ========================
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  -- ========================
  -- Keybindings (Matching CoC)
  -- ========================
  mapping = cmp.mapping.preset.insert({
    -- <C-j>: Next completion item (CoC: <C-j>)
    ['<C-j>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),

    -- <C-k>: Previous completion item (CoC: <C-k>)
    ['<C-k>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),

    -- <CR>: Confirm completion (CoC: <CR>)
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false, -- Don't auto-select first item
    }),

    -- <C-Space>: Trigger completion (CoC: <C-Space>)
    ['<C-Space>'] = cmp.mapping.complete(),

    -- <C-e>: Close completion menu
    ['<C-e>'] = cmp.mapping.abort(),

    -- <C-d>: Scroll docs down
    ['<C-d>'] = cmp.mapping.scroll_docs(4),

    -- <C-u>: Scroll docs up
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
  }),

  -- ========================
  -- Completion Sources
  -- Priority order: LSP > buffer > path > snippets
  -- ========================
  sources = cmp.config.sources({
    {
      name = 'nvim_lsp',
      priority = 1000,
      -- Show more items from LSP
      max_item_count = 20,
    },
    {
      name = 'luasnip',
      priority = 750,
      max_item_count = 5,
    },
    {
      name = 'path',
      priority = 500,
    },
  }, {
    -- Lower priority sources (only if nothing from above)
    {
      name = 'buffer',
      priority = 250,
      option = {
        -- Search in all visible buffers
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
  }),

  -- ========================
  -- Completion Menu Formatting
  -- ========================
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      -- Icon + Kind name
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)

      -- Source name in menu
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        luasnip = '[Snippet]',
        buffer = '[Buffer]',
        path = '[Path]',
      })[entry.source.name]

      return vim_item
    end,
  },

  -- ========================
  -- Experimental Features
  -- ========================
  experimental = {
    ghost_text = false, -- Don't show ghost text (can be distracting)
  },

  -- ========================
  -- Completion Behavior
  -- ========================
  completion = {
    completeopt = 'menu,menuone,noinsert', -- CoC-like behavior
  },

  -- ========================
  -- Sorting/Ranking
  -- ========================
  sorting = {
    priority_weight = 2,
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
})

-- ============================================================================
-- FILETYPE-SPECIFIC COMPLETION
-- ============================================================================

-- Use buffer source for `/` search (cmdline search)
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})

-- Use cmdline & path source for `:` (cmdline commands)
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})

-- ============================================================================
-- LUASNIP CONFIGURATION
-- ============================================================================

luasnip.config.setup({
  history = true, -- Keep last snippet local for jumpback
  update_events = 'TextChanged,TextChangedI', -- Update snippets as you type
  enable_autosnippets = true,
  -- Visual selection expansion
  store_selection_keys = '<Tab>',
})

-- Key bindings for snippet navigation (in addition to <C-j>/<C-k> above)
vim.keymap.set({ 'i', 's' }, '<Tab>', function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    return '<Tab>'
  end
end, { expr = true, silent = true })

vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    return '<S-Tab>'
  end
end, { expr = true, silent = true })
