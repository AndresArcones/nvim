-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps
---------------------
-- make esc easy again
keymap.set("i", "jk", "<ESC>")
keymap.set("c", "jk", "<ESC>")

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>") -- increment
keymap.set("n", "<leader>-", "<C-x>") -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window

keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tab

----------------------
-- Plugin Keybinds
----------------------

-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle split window maximization

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

-- telescope git commands
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>") -- list current changes per file with diff preview ["gs" for git status]

-- restart lsp server
keymap.set("n", "<leader>rs", ":LspRestart<CR>") -- mapping to restart lsp if necessary

-- fugitive keybindings
keymap.set("n", "<leader>g", vim.cmd.Git) -- opens a buffer to execute git commands

local colduck = vim.api.nvim_create_augroup("colduck", {})

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
  group = colduck,
  pattern = "*",
  callback = function()
    if vim.bo.ft ~= "fugitive" then
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "<leader>p", function()
      vim.cmd.Git("push")
    end, opts)

    -- rebase always
    vim.keymap.set("n", "<leader>P", function()
      vim.cmd.Git({ "pull", "--rebase" })
    end, opts)

    -- NOTE: It allows me to easily set the branch I am pushing and any tracking
    -- needed if I did not set the branch up correctly
    vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)
  end,
})

-- harpoon keybindings
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

keymap.set("n", "<leader>a", mark.add_file)
keymap.set("n", "<leader>h", ui.toggle_quick_menu)

-- TEMPORAL REMOVE
-- keymap.set("n", "<C-1>", function()
--   ui.nav_file(1)
-- end)
-- keymap.set("n", "<C-2>", function()
--   ui.nav_file(2)
-- end)
-- keymap.set("n", "<C-3>", function()
--   ui.nav_file(3)
-- end)
-- keymap.set("n", "<C-4>", function()
--   ui.nav_file(4)
-- end)

-- undotree kebindings
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- zen mode keybindings
--
require("zen-mode").setup({
  window = {
    width = 90,
    options = {
      number = true,
      relativenumber = false,
    },
  },
})
vim.keymap.set("n", "<leader>zz", function()
  require("zen-mode").toggle()
  vim.wo.wrap = false
end)

-- navigator
keymap.set({'n', 't'}, '<C-h>', '<CMD>NavigatorLeft<CR>')
keymap.set({'n', 't'}, '<C-l>', '<CMD>NavigatorRight<CR>')
keymap.set({'n', 't'}, '<C-k>', '<CMD>NavigatorUp<CR>')
keymap.set({'n', 't'}, '<C-j>', '<CMD>NavigatorDown<CR>')
keymap.set({'n', 't'}, '<C-p>', '<CMD>NavigatorPrevious<CR>')
