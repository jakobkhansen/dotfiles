local vimp = require('vimp')
local nnoremap = vimp.nnoremap
local noremap = vimp.nnoremap
local vnoremap = vimp.vnoremap
local vimscript = vim.api.nvim_exec

vimscript('noremap <silent> # :call nerdcommenter#Comment(0, "toggle")<CR>', false)

vim.g.NERDCreateDefaultMappings = 0
