-- define the command to run on save
COMMAND_TO_RUN = "make format"
COMMAND_TO_RUN2 = "make run"

-- set up the autocmd to run the command on save
vim.cmd([[
  augroup my_python_autocmds
    autocmd!
    autocmd BufWritePost *.py :lua EXECUTE_COMMAND(COMMAND_TO_RUN)
  augroup END
]])


-- vim.cmd([[
--   augroup my_python_autocmds2
--     autocmd!
--     autocmd BufWritePost __main__.py :lua EXECUTE_COMMAND(COMMAND_TO_RUN2)
--   augroup END
-- ]])

-- define the function to execute the command
function EXECUTE_COMMAND(command)
  local current_file = vim.fn.expand("%:p")
  if vim.fn.filereadable(current_file) == 1 then
    vim.fn.jobstart(command, {
      cwd = vim.fn.getcwd(),
      on_exit = function(job_id, exit_code, event_type)
        if exit_code == 0 then
          print(command .." executed successfully")
        else
          print(command .." failed with exit code: " .. exit_code)
        end
        vim.cmd(":edit")
      end
    })
  end
end
