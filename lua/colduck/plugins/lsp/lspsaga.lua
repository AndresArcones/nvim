-- import lspsaga safely
local saga_status, saga = pcall(require, "lspsaga")
if not saga_status then
  return
end

saga.setup({
  definition = {
    keys = {
      edit = "<CR>", -- use enter to open file with definition preview
    },
  },
  ui = {
    colors = {
      normal_bg = "#022746",
    },
  },
})
