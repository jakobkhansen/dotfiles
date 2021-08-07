local remap = vim.api.nvim_set_keymap
local vimscript = vim.api.nvim_exec

local vimp = require('vimp')
local map = vimp.map
local noremap = vimp.noremap
local nmap = vimp.nmap
local nnoremap = vimp.nnoremap
local vmap = vimp.vmap
local vnoremap = vimp.vnoremap
local tmap = vimp.tmap
local tnoremap = vimp.tnoremap

-- Remaps
remap('', '+', '$', { noremap = true })
remap('', '""', '"+y', { noremap = true })
remap('', '<LeftMouse>', '<Nop>', { noremap = true })

-- Movement
remap('', 'J', '10j', {})
remap('', 'K', '10k', {})

remap('', ';', ',', { noremap = true })
remap('', ',', ';', { noremap = true })

-- Text manipulation
remap('n', 'Q', 'gqap', { silent = true, noremap = true })
remap('n', '<A-k>', '<CMD>m-2<CR>', { noremap = true })
remap('n', '<A-j>', '<CMD>m+<CR>', { noremap = true })

-- Buffers and tabs

remap('n', '<Tab>', '<CMD>bn<CR>', {})
remap('n', '<S-Tab>', '<CMD>bp<CR>', {})

remap('n', '<A-Tab>', '<CMD>tabNext<CR>', {})
remap('n', '<A-S-Tab>', '<CMD>tabprevious<CR>', {})

--  Move to buffer
remap('n', '<C-h>', '<C-w>h', { noremap = true })
remap('n', '<C-j>', '<C-w>j', { noremap = true })
remap('n', '<C-k>', '<C-w>k', { noremap = true })
remap('n', '<C-l>', '<C-w>l', { noremap = true })

--  Resize buffers
remap('n', '<C-M-h', 'vertical resize-5', { noremap = true })
remap('n', '<C-M-j', 'resize-5', { noremap = true })
remap('n', '<C-M-k', 'resize+5', { noremap = true })
remap('n', '<C-M-l', 'vertical resize+5', { noremap = true })
remap('n', '<C-M-r', '<C-W>=', { noremap = true })

--  Move horizontally
remap('n', 'zh', '10zh', { noremap = true })
remap('n', 'zl', '10zl', { noremap = true })

--  Delete all buffers to left and right
remap('', '<F2>', '<CMD>2,-1budfo bd!<CR>', {})
remap('', '<F3>', '<CMD>+1,$budfo bd!<CR>', {})

-- Terminal
tnoremap({'silent'}, '<C-q>', '<Esc>')
tnoremap({'silent'}, '<Esc>', '<C-\\><C-n>')

tnoremap('<C-h>', '<C-\\><C-n><C-w>h')
tnoremap('<C-j>', '<C-\\><C-n><C-w>j')
tnoremap('<C-k>', '<C-\\><C-n><C-w>k')
tnoremap('<C-l>', '<C-\\><C-n><C-w>l')

tnoremap('<C-M-h>', '<C-\\><C-n><CMD>vertical resize-5<CR>i')
tnoremap('<C-M-j>', '<C-\\><C-n><CMD>resize-5<CR>i')
tnoremap('<C-M-k>', '<C-\\><C-n><CMD>resize+5<CR>i')
tnoremap('<C-M-l>', '<C-\\><C-n><CMD>vertical resize+5<CR>i')
tnoremap('<C-M-r>', '<C-\\><C-n><C-W>=i')

vimscript('au TermOpen * map <buffer> <Leader>bc ipwd\\|xclip -selection clipboard<CR><C-\\><C-n>:cd <C-r>+<CR>i', false)

vimscript('au TermOpen * startinsert', false)
