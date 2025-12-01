-- import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
  return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
  return
end

-- import typescript plugin safely
local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
  return
end

local keymap = vim.keymap -- for conciseness

-- enable keybinds only when lsp server available
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- Lspsaga keybindings
  keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts)             -- show definition, references
  keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)  -- go to declaration
  keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)        -- peek definition
  keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
  keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)    -- code actions
  keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)         -- rename symbol
  keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- line diagnostics
  keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- cursor diagnostics
  keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)   -- prev diagnostic
  keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)   -- next diagnostic
  keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)               -- hover docs
  keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts)         -- outline toggle

  -- typescript specific keymaps (rename file, organize imports, remove unused)
  if client.name == "ts_ls" then
    keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>", opts)       -- rename file and update imports
    keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>", opts)  -- organize imports
    keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>", opts)     -- remove unused variables
  end
end

-- enable autocompletion capabilities
local capabilities = cmp_nvim_lsp.default_capabilities()

-- diagnostic symbols in sign column
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- servers setup --

lspconfig["html"].setup({ capabilities = capabilities, on_attach = on_attach })

typescript.setup({
  server = {
    capabilities = capabilities,
    on_attach = on_attach,
  },
})

lspconfig["cssls"].setup({ capabilities = capabilities, on_attach = on_attach })

lspconfig["tailwindcss"].setup({ capabilities = capabilities, on_attach = on_attach })

lspconfig["emmet_ls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})

lspconfig["lua_ls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
})

lspconfig["pyright"].setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig["clangd"].setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig["gopls"].setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig["bashls"].setup({ capabilities = capabilities, on_attach = on_attach })

lspconfig["terraformls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "terraform", "hcl" },
})

lspconfig["yamlls"].setup({ capabilities = capabilities, on_attach = on_attach })

-- Uncomment to enable spectral language server
-- lspconfig["spectral"].setup({
--   capabilities = capabilities,
--   on_attach = on_attach,
-- })
