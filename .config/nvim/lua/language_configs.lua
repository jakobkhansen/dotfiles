local vimscript = vim.api.nvim_exec

vimscript('au FileType javascript,typescript,typescriptreact setlocal sts=2 ts=2 sw=2', false)
vimscript('au FileType norg setlocal sts=2 ts=2 sw=2', false)
