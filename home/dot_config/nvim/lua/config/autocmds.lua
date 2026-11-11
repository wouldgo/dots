local group = vim.api.nvim_create_augroup("config", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- files.trimTrailingWhitespace + files.trimFinalNewlines; the final newline
-- itself is written by 'fixendofline'
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  callback = function(args)
    local bo = vim.bo[args.buf]
    if bo.binary or not bo.modifiable or bo.buftype ~= "" then
      return
    end
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns silent! %s/\s\+$//e]])
    vim.cmd([[keeppatterns silent! %s/\n\+\%$//e]])
    vim.fn.winrestview(view)
  end,
})

-- The Shift+arrows selection (Select mode) leaves out the character under the
-- cursor, as if the cursor were between characters like in VSCode. Visual
-- mode stays inclusive: treesitter selections and plugins expect it.
vim.api.nvim_create_autocmd("ModeChanged", {
  group = group,
  pattern = "*:s",
  callback = function()
    vim.o.selection = "exclusive"
  end,
})
vim.api.nvim_create_autocmd("ModeChanged", {
  group = group,
  pattern = { "*:n*", "*:i*" },
  callback = function()
    vim.o.selection = "inclusive"
  end,
})

-- Quitting the last file quits nvim: the side windows (explorer, debug views,
-- terminal) do not keep it open
vim.api.nvim_create_autocmd("QuitPre", {
  group = group,
  callback = function()
    local current = vim.api.nvim_get_current_win()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    for _, win in ipairs(wins) do
      local buf = vim.api.nvim_win_get_buf(win)
      local floating = vim.api.nvim_win_get_config(win).relative ~= ""
      if win ~= current and not floating and vim.bo[buf].buftype == "" then
        return
      end
    end
    for _, win in ipairs(wins) do
      if win ~= current and vim.api.nvim_win_is_valid(win) then
        pcall(vim.api.nvim_win_close, win, true)
      end
    end
  end,
})

-- Reload files changed outside nvim (git checkout, formatters, ...)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = group,
  command = "silent! checktime",
})
