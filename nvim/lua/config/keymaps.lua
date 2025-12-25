-- Copy relative file path with line number
vim.keymap.set("n", "<leader>apl", function()
  local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
  local line = vim.fn.line(".")
  local result = string.format("%s:%d", path, line)
  vim.fn.setreg("+", result)
  vim.notify("Copied: " .. result)
end, { desc = "Copy relative file path with line number" })

-- Copy relative file path without line number
vim.keymap.set("n", "<leader>apf", function()
  local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy relative file path" })

vim.keymap.set("n", "<leader>afd", function()
  local current_file = vim.fn.expand("%:p")
  local command = string.format("silent !rm %s", current_file)
  vim.cmd(command)
  vim.cmd("bdelete")
  vim.notify("file deleted: " .. current_file)
end, { desc = "Delete current file" })

vim.keymap.set("n", "<leader>afn", function()
  local name = vim.fn.expand('%:t');
  vim.fn.setreg("+", name)
  vim.notify("file name copied: " .. name)
end, {desc = "copy file name"})

-- CTRL-q (insert-mode) manually triggers Amazon Q completion (inline suggestions).
vim.keymap.set("i", "<c-q>", function()
  local client = vim.lsp.get_clients({ bufnr = 0, name = "amazonq-completion" })[1]
  if not client then
    vim.notify("Amazon Q not enabled for this buffer")
    return
  end
  vim.lsp.completion.enable(true, client.id, 0)
  vim.notify("Amazon Q: working...")
  vim.lsp.completion.get()
  -- vim.cmd[[redraw | echo '']]
end)

vim.keymap.set("n", "<leader>abc", function()
  local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
  vim.fn.setreg("+", branch)
  print("Copied branch: " .. branch)
end, { desc = "Copy current git branch" })
