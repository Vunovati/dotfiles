vim.cmd([[nnoremap <silent> <leader>t :Format<CR>]])

function format_prettier()
   return {
     exe = "npx",
     args = {"prettier", "--stdin-filepath", vim.api.nvim_buf_get_name(0)},
     stdin = true
   }
end

require('formatter').setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  filetype = {
    typescript = { 
      format_prettier
    },
    typescriptreact = { 
      format_prettier
    },
    javascript = { 
      format_prettier
    },
    javascriptreact = { 
      format_prettier
    },
    json = { 
      format_prettier
    }
  }
}
