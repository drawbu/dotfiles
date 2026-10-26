-- jump between test and source file
vim.keymap.set('n', '<C-n>', function()
  -- check if a _test.go file exists
  local test_file = vim.fn.expand('%:p:h') .. '/' .. vim.fn.expand('%:t:r') .. '_test.go'
  if vim.fn.filereadable(test_file) == 1 then
    vim.cmd('e ' .. test_file)
    return
  end

  -- check if file is a test file
  if string.match(vim.fn.expand('%:t'), '_test.go$') then
    local main_file = vim.fn.expand('%:p:h') .. '/' .. string.gsub(vim.fn.expand('%:t:r'), '_test', '') .. '.go'
    if vim.fn.filereadable(main_file) == 1 then
      vim.cmd('e ' .. main_file)
    end
  end
end, { desc = 'Jump between test and source file', silent = true })
