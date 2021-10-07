vimscript = vim.api.nvim_exec
vim.g.auto_save = 1
vim.g.auto_save_silent = 1
vim.g.auto_save_events = { 'CursorHold', 'InsertLeave', 'TextChanged' }
vimscript('au FileType javascript let b:auto_save = 0', false)
