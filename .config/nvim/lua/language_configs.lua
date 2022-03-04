local vimscript = vim.api.nvim_exec

vimscript('au FileType javascript,javascriptreact,typescript,typescriptreact setlocal sts=2 ts=2 sw=2', false)
vimscript('au FileType norg setlocal sts=2 ts=2 sw=2', false)
vimscript('au FileType cpp,cmake setlocal sts=2 ts=2 sw=2', false)
vimscript('au BufRead,BufNewFile *.abs set filetype=abs', false)
vimscript('au BufRead,BufNewFile *.cup set filetype=cup', false)
vimscript('au BufRead,BufNewFile *.cmp set filetype=cmp', false)
