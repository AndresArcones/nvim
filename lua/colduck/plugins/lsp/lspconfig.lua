-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
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

-- servers setup using vim.lsp.config

local lsp_configs = {
  html = { capabilities = capabilities, on_attach = on_attach },
  cssls = { capabilities = capabilities, on_attach = on_attach },
  tailwindcss = { capabilities = capabilities, on_attach = on_attach },
  emmet_ls = {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
  },
  lua_ls = {
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
  },
  pyright = { capabilities = capabilities, on_attach = on_attach },
  clangd = { capabilities = capabilities, on_attach = on_attach },
  gopls = { capabilities = capabilities, on_attach = on_attach },
  bashls = { capabilities = capabilities, on_attach = on_attach },
  terraformls = {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "terraform", "hcl" },
  },
  yamlls = { capabilities = capabilities, on_attach = on_attach },
}

-- Configure all LSP servers
for server_name, config in pairs(lsp_configs) do
  vim.lsp.config(server_name, config)
  vim.lsp.enable(server_name)
end

-- Configure TypeScript using vim.lsp.config
vim.lsp.config("ts_ls", {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    typescript = {
      preferences = {
        includeCompletionsForModuleExports = true,
        includeCompletionsWithInsertText = true,
      },
    },
    javascript = {
      preferences = {
        includeCompletionsForModuleExports = true,
        includeCompletionsWithInsertText = true,
      },
    },
  },
})
vim.lsp.enable("ts_ls")

-- Uncomment to enable spectral language server
-- lspconfig["spectral"].setup({
--   capabilities = capabilities,
--   on_attach = on_attach,
-- })
