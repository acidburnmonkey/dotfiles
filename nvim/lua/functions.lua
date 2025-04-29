local M = {}

function M.toggle_floaterm()
  local bufnr = vim.fn 
  if bufnr ~= -1 then
    vim.cmd('FloatermHide')
else
    vim.notify("No Floaterm open.", vim.log.levels.INFO)
  end
end

function M.replace_word_under_cursor_in_selection()
  local current_pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd('normal! gv')
  local word = vim.fn.expand('<cword>')
  local replacement = vim.fn.input("Replace '" .. word .. "' with: ")
  vim.api.nvim_win_set_cursor(0, current_pos)
  if replacement ~= '' then
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    vim.cmd(start_line .. ',' .. end_line .. 's/' .. word .. '/' .. replacement .. '/g')
  end
end


function M.bufonly()
  vim.cmd('silent! execute "%bd|e#|bd#"')
end

function M.remove_trailing_whitespace()
  local saved_search = vim.fn.getreg('/')
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.setreg('/', saved_search)
end

return M

