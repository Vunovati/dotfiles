-- ============================================================================
-- LSP CONFIGURATION
-- Native Neovim LSP setup replacing CoC.nvim
--
-- This file configures:
-- - LSP server settings and capabilities
-- - Keybindings (matching CoC for zero workflow disruption)
-- - Diagnostics appearance and behavior
-- - Auto-formatting on save
-- - UI improvements (borders, handlers)
-- ============================================================================

local M = {}

-- ============================================================================
-- DIAGNOSTIC CONFIGURATION
-- How errors/warnings are displayed
-- ============================================================================
vim.diagnostic.config({
  -- Show diagnostics in virtual text (inline with code)
  virtual_text = {
    prefix = '●', -- Could be '■', '▎', 'x', '●'
    source = 'if_many', -- Show source if multiple sources
  },
  -- Show diagnostics in sign column (left gutter)
  signs = true,
  -- Underline problematic code
  underline = true,
  -- Update diagnostics while typing (vs only on save)
  update_in_insert = false,
  -- Sort diagnostics by severity
  severity_sort = true,
  -- Show diagnostics in floating window on hover
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

-- Define diagnostic signs (icons in the sign column)
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- ============================================================================
-- LSP HANDLERS
-- Customize how LSP UI elements are displayed
-- ============================================================================

-- Hover window with border
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = "rounded" }
)

-- Signature help window with border
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = "rounded" }
)

-- ============================================================================
-- LSP KEYBINDINGS
-- Matches CoC keybindings exactly for zero disruption
-- These are attached when LSP server attaches to a buffer
-- ============================================================================

M.on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  local keymap = vim.keymap.set

  -- ========================
  -- Go To Navigation
  -- ========================
  -- Go to definition (CoC: gd)
  keymap('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to definition' }))

  -- Go to type definition (CoC: gy)
  keymap('n', 'gy', vim.lsp.buf.type_definition, vim.tbl_extend('force', opts, { desc = 'Go to type definition' }))

  -- Go to implementation (CoC: gi)
  keymap('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = 'Go to implementation' }))

  -- Go to references (CoC: gr)
  keymap('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'Go to references' }))

  -- ========================
  -- Documentation & Hints
  -- ========================
  -- Show hover documentation (CoC: K)
  keymap('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover documentation' }))

  -- Show signature help (optional, lsp-signature.nvim does this automatically)
  keymap('i', '<C-h>', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'Signature help' }))

  -- ========================
  -- Diagnostics Navigation
  -- ========================
  -- Next diagnostic (CoC: ]d)
  keymap('n', ']d', vim.diagnostic.goto_next, vim.tbl_extend('force', opts, { desc = 'Next diagnostic' }))

  -- Previous diagnostic (CoC: [d)
  keymap('n', '[d', vim.diagnostic.goto_prev, vim.tbl_extend('force', opts, { desc = 'Previous diagnostic' }))

  -- ========================
  -- Code Actions & Refactoring
  -- ========================
  -- Code actions (CoC: <leader>a, <leader>ac)
  keymap({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code action' }))
  keymap('n', '<leader>ac', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code action (cursor)' }))

  -- Rename symbol (CoC: <leader>rn)
  keymap('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))

  -- Quick fix (CoC: <leader>qf) - use first code action
  keymap('n', '<leader>qf', function()
    vim.lsp.buf.code_action({ apply = true })
  end, vim.tbl_extend('force', opts, { desc = 'Quick fix' }))

  -- ========================
  -- Formatting
  -- ========================
  -- Format buffer (CoC: <leader>f in visual, handled by conform.nvim for <leader>F)
  -- This provides LSP formatting as fallback
  keymap('n', '<leader>lf', function()
    vim.lsp.buf.format({ async = true })
  end, vim.tbl_extend('force', opts, { desc = 'Format buffer (LSP)' }))

  -- ========================
  -- Workspace & Symbols
  -- ========================
  -- List workspace symbols (CoC: <space>s)
  keymap('n', '<space>s', vim.lsp.buf.workspace_symbol, vim.tbl_extend('force', opts, { desc = 'Workspace symbols' }))

  -- List document symbols (CoC: <space>o, but Telescope is better for this)
  keymap('n', '<space>o', vim.lsp.buf.document_symbol, vim.tbl_extend('force', opts, { desc = 'Document symbols' }))

  -- ========================
  -- Highlight References
  -- ========================
  -- Highlight symbol under cursor and its references (CoC does this on CursorHold)
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup('lsp_document_highlight', { clear = false })
    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = 'lsp_document_highlight' })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = 'lsp_document_highlight',
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = 'lsp_document_highlight',
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- ========================
  -- Format on Save
  -- ========================
  -- Auto-format on save (conform.nvim handles this, but LSP can be fallback)
  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('LspFormatting', { clear = false }),
      buffer = bufnr,
      callback = function()
        -- Only format if conform.nvim isn't handling it
        -- conform takes precedence (it's configured in plugins/init.lua)
        if not pcall(require, 'conform') then
          vim.lsp.buf.format({ async = false, timeout_ms = 1000 })
        end
      end,
    })
  end
end

-- ============================================================================
-- LSP SERVER CAPABILITIES
-- Tell LSP servers what nvim-cmp can do (for better completions)
-- ============================================================================

M.capabilities = vim.lsp.protocol.make_client_capabilities()

-- Add nvim-cmp capabilities if available
local cmp_lsp_ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_lsp_ok then
  M.capabilities = cmp_lsp.default_capabilities(M.capabilities)
end

-- Enable snippet support
M.capabilities.textDocument.completion.completionItem.snippetSupport = true

-- ============================================================================
-- LSP SERVER CONFIGURATIONS
-- Specific settings for each LSP server
-- Servers are auto-installed via mason-lspconfig (in plugins/init.lua)
-- ============================================================================

local lspconfig = require('lspconfig')

-- TypeScript/JavaScript (ts_ls, formerly tsserver)
lspconfig.ts_ls.setup({
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  -- TypeScript-specific settings
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
})

-- Lua (lua_ls) - Neovim config LSP
lspconfig.lua_ls.setup({
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  settings = {
    Lua = {
      -- Tell LSP about Neovim runtime
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Recognize 'vim' global
        globals = { 'vim' },
      },
      workspace = {
        -- Make LSP aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false, -- Don't ask about luassert/busted
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

-- JSON
lspconfig.jsonls.setup({
  on_attach = M.on_attach,
  capabilities = M.capabilities,
})

-- YAML
lspconfig.yamlls.setup({
  on_attach = M.on_attach,
  capabilities = M.capabilities,
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
    },
  },
})

-- Bash
lspconfig.bashls.setup({
  on_attach = M.on_attach,
  capabilities = M.capabilities,
})

-- ============================================================================
-- USER COMMANDS
-- Replicate some CoC commands for familiarity
-- ============================================================================

-- :OR (Organize Imports) - TypeScript/JavaScript
vim.api.nvim_create_user_command('OR', function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { 'source.organizeImports' },
      diagnostics = {},
    },
  })
end, { desc = 'Organize imports' })

-- :Format (Format current buffer)
vim.api.nvim_create_user_command('Format', function()
  vim.lsp.buf.format({ async = true })
end, { desc = 'Format buffer with LSP' })

return M
