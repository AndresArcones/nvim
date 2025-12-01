-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps
---------------------

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- window management
keymap.set("n", "<leader>sv", "<C-w>v")        -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s")        -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=")        -- make split windows equal width & height
keymap.set("n", "<leader>sx", ":close<CR>")    -- close current split window

keymap.set("n", "<leader>to", ":tabnew<CR>")   -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>")     --  go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>")     --  go to previous tab

----------------------
-- Plugin Keybinds
----------------------

-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle split window maximization

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")  -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>")   -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")     -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")   -- list available help tags

-- telescope git commands
keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>")   -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>")  -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>")    -- list current changes per file with diff preview ["gs" for git status]

-- fugitive keybindings
keymap.set("n", "<leader>g", vim.cmd.Git) -- opens a buffer to execute git commands

-- lsp
keymap.set("n", "<leader>rs", ":LspRestart<CR>")                         -- mapping to restart lsp if necessary
keymap.set("n", "gf", "<cmd>Lspsaga finder<CR>")                         -- show fefinition, references
keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>")          -- got to declaration
keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>")                -- see definition and make edits in window
keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")       -- go to implementation
keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>")            -- see available code actions
keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>")                 -- smart rename
keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>")   -- show  diagnostics for line
keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>") -- show diagnostics for cursor
keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>")           -- jump to previous diagnostic in buffer
keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>")           -- jump to next diagnostic in buffer
keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>")                       -- show documentation for what is under cursor
keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>")                 -- see outline on right hand side
keymap.set("n", "<leader>cl", "<Cmd>lua vim.lsp.codelens.run()<CR>")
keymap.set("n", "<leader>f", "<Cmd>lua vim.lsp.buf.format()<CR>")

-- tmux
vim.keymap.set("n", "<C-P>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- dapui
keymap.set("n", "<leader>ds", function() require('dapui').toggle() end)

-- dap
keymap.set("n", "<leader>dc", function()
  require("dap").continue()
end)

keymap.set("n", "<leader>dr", function()
  require("dap").repl.toggle()
end)

keymap.set("n", "<leader>dK", function()
  require("dap.ui.widgets").hover()
end)

keymap.set("n", "<leader>dt", function()
  require("dap").toggle_breakpoint()
end)

keymap.set("n", "<leader>do", function()
  require("dap").step_over()
end)

keymap.set("n", "<leader>di", function()
  require("dap").step_into()
end)

keymap.set("n", "<leader>dl", function()
  require("dap").run_last()
end)

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
keymap.set({ 'n', 't' }, '<C-h>', '<CMD>NavigatorLeft<CR>')
keymap.set({ 'n', 't' }, '<C-l>', '<CMD>NavigatorRight<CR>')
keymap.set({ 'n', 't' }, '<C-k>', '<CMD>NavigatorUp<CR>')
keymap.set({ 'n', 't' }, '<C-j>', '<CMD>NavigatorDown<CR>')

-- neotest
keymap.set("n", "<leader>t", ":Neotest run<CR>", { desc = "Run nearest test" })
keymap.set("n", "<leader>T", ":Neotest run file<CR>", { desc = "Run all tests in file" })
keymap.set("n", "<leader>s", ":Neotest summary<CR>", { desc = "Show test summary" })
