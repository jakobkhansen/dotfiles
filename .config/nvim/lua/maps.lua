local remap = vim.api.nvim_set_keymap
local vimscript = vim.api.nvim_exec

local vimp = require('vimp')
local map = vimp.map
local noremap = vimp.noremap
local nmap = vimp.nmap
local nnoremap = vimp.nnoremap
local imap = vimp.imap
local inoremap = vimp.inoremap
local vmap = vimp.vmap
local vnoremap = vimp.vnoremap
local tmap = vimp.tmap
local tnoremap = vimp.tnoremap

-- Remaps
noremap('+', '$')
noremap('""', '"+y')
noremap('<LeftMouse>', '<Nop>')
inoremap('<LeftMouse>', '<Nop>')

-- Movement
map('J', '10j')
map('K', '10k')

noremap(';', ',')
noremap(',', ';')

-- Text manipulation
noremap({silent = true}, 'Q', 'gqap')
noremap('<A-k>', '<CMD>m-2<CR>')
noremap('<A-j>', '<CMD>m+<CR>')

-- Buffers and tabs

nmap('<Tab>', '<CMD>bn<CR>')
nmap('<S-Tab>', '<CMD>bp<CR>')

nmap('<A-S-Tab>', '<CMD>tabprevious<CR>')
nmap('<A-Tab>', '<CMD>tabNext<CR>')

--  Move to buffer
nnoremap('<C-h>', '<C-w>h')
nnoremap('<C-j>', '<C-w>j')
nnoremap('<C-k>', '<C-w>k')
--nnoremap('<C-l>', '<C-w>l')
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {noremap = true})

--  Resize buffers
nnoremap('<C-M-h>', '<CMD>vertical resize-5<CR>')
nnoremap('<C-M-j>', '<CMD>resize-5<CR>')
nnoremap('<C-M-k>', '<CMD>resize+5<CR>')
nnoremap('<C-M-l>', '<CMD>vertical resize+5<CR>')
nnoremap('<C-A-r>', '<C-W>=')

--  Move horizontally
noremap('zh', '10zh')
noremap('zl', '10zl')

--  Delete all buffers to left and right
map('<F2>', '<CMD>2,-1bufdo bd!<CR>')
map('<F3>', '<CMD>+1,$bufdo bd!<CR>')

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
