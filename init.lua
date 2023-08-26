require("colduck.plugins-setup")
require("colduck.core.options")
require("colduck.core.keymaps")
require("colduck.core.colorscheme")
require("colduck.plugins.comment")
require("colduck.plugins.nvim-tree")
require("colduck.plugins.lualine")
require("colduck.plugins.telescope")
require("colduck.plugins.nvim-cmp")
require("colduck.plugins.lsp.mason")
require("colduck.plugins.lsp.lspsaga")
require("colduck.plugins.lsp.lspconfig")
require("colduck.plugins.lsp.metals-scala")
require("colduck.plugins.lsp.null-ls")
require("colduck.plugins.autopairs")
require("colduck.plugins.treesitter")
require("colduck.plugins.gitsigns")
require("colduck.plugins.dap")
require("colduck.autoexecute")


-- -- ~/.config/nvim/init.lua
--
-- -- Initialize Packer
-- local packer = require('packer')
--
-- packer.startup(function()
--     -- Add plugins
--     use 'scalameta/nvim-metals'
--     use 'glepnir/lspsaga.nvim'
-- end)
--
-- -- Automatically run :PackerCompile whenever plugins.lua is updated
-- vim.cmd([[autocmd BufWritePost plugins.lua PackerCompile]])
--
-- -- Load plugins
-- require('packer').sync()
-- -- ~/.config/nvim/init.lua
--
-- -- Configure LSP and nvim-metals
-- local lspconfig = require('lspconfig')
-- local metals = require('metals')
--
-- -- Set up nvim-metals
-- metals.config:configure_metals_bin()
-- metals.config:configure_ui()
--
-- -- Configure language server
-- lspconfig.metals.setup({
--     on_attach = require('lspsaga').on_attach,
--     capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- })
--
--
-- -- ~/.config/nvim/init.lua
--
