-- auto install lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- plugin specs
local plugins = {
  -- UI and visuals
  { "bluz71/vim-nightfly-guicolors" },
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-tree/nvim-tree.lua" },
  { "nvim-lualine/lualine.nvim" },
  { "rose-pine/neovim", name = "rose-pine" },

  -- Editing
  { "szw/vim-maximizer" },
  { "tpope/vim-surround" },
  { "inkarkat/vim-ReplaceWithRegister" },
  { "numToStr/Comment.nvim" },
  { "windwp/nvim-autopairs" },
  { "windwp/nvim-ts-autotag", dependencies = { "nvim-treesitter/nvim-treesitter" } },
  { "theprimeagen/harpoon" },
  { "mbbill/undotree" },
  { "folke/zen-mode.nvim" },
  { "eandrju/cellular-automaton.nvim" },
  { "mhinz/vim-startify" },
  { "dstein64/vim-startuptime" },
  { "junegunn/gv.vim" },
  { "lewis6991/gitsigns.nvim" },

  -- Telescope
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  { "nvim-telescope/telescope.nvim", branch = "0.1.x" },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })()
    end,
  },
  { "nvim-treesitter/playground" },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },

  -- Snippets (optional, lazy loaded)
  { "hrsh7th/vim-vsnip", lazy = true },
  { "hrsh7th/cmp-vsnip", lazy = true },

  -- LSP
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "onsails/lspkind.nvim" },
  { "glepnir/lspsaga.nvim", branch = "main" },
  { "jose-elias-alvarez/typescript.nvim" },

  -- none-ls replacement (null-ls successor)
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-lspconfig" },
  },
  {
    "jayp0521/mason-null-ls.nvim",
    dependencies = { "nvimtools/none-ls.nvim" },
  },

  -- Scala + DAP
  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
  },
  { "nvim-neotest/nvim-nio" },

  -- Wakatime
  { "wakatime/vim-wakatime" },

  -- Navigation
  {
    "numToStr/Navigator.nvim",
    config = function()
      require("Navigator").setup()
    end,
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = { "markdown" },
    config = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },
}

-- Setup lazy.nvim with plugins
require("lazy").setup(plugins, {
  dev = {
    path = "~/projects",
    patterns = {},
    fallback = false,
  },
  ui = {
    border = "rounded",
  },
  performance = {
    cache = { enabled = true },
  },
})
