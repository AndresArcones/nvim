-- import none-ls plugin safely
local setup, null_ls = pcall(require, "none-ls")
if not setup then
  return
end

-- for conciseness
local formatting = null_ls.builtins.formatting -- to setup formatters
local diagnostics = null_ls.builtins.diagnostics -- to setup linters

-- to setup format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- configure none-ls
null_ls.setup({
  sources = {
    -- formatters
    formatting.stylua, -- Lua
    formatting.gofmt,  -- Go

    -- linters
    diagnostics.flake8, -- Python
    diagnostics.eslint.with({ -- JS/TS linter
      condition = function(utils)
        return utils.root_has_file(".eslintrc.js") or utils.root_has_file(".eslintrc.json")
      end,
    }),
  },

  -- format on save
  on_attach = function(current_client, bufnr)
    if current_client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            filter = function(client)
              -- only use none-ls for formatting
              return client.name == "null-ls" -- still called "null-ls" internally
            end,
            bufnr = bufnr,
          })
        end,
      })
    end
  end,
})
