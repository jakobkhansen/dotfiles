local remap = vim.api.nvim_set_keymap
local vimscript = vim.api.nvim_exec
local command = vim.api.nvim_command

local lsp = vim.lsp.buf
local diagnostic = vim.lsp.diagnostic

local vimp = require('vimp')
local map = vimp.map
local noremap = vimp.noremap
local nmap = vimp.nmap
local nnoremap = vimp.nnoremap
local vmap = vimp.vmap
local vnoremap = vimp.vnoremap


vim.g.mapleader = ' '


lmap = {}

-- Find x
map('<Leader>ff', '<CMD>Telescope find_files prompt_prefix=🔍<CR>')
map('<Leader>fhf', '<CMD>Telescope find_files find_command=rg,--files,/home/ prompt_prefix=🔍<CR>')
map('<Leader>fhh', '<CMD>Telescope find_files find_command=rg,--files,--hidden,/home/ prompt_prefix=🔍<CR>')
map('<Leader>fg', '<CMD>Telescope git_files prompt_prefix=🔍<CR>')
map('<Leader>fc', '<CMD>Telescope live_grep prompt_prefix=🔍<CR>')
map('<Leader>fl', '<CMD>NvimTreeToggle<CR>')
map('<Leader>fr', '<CMD>Ranger --choosedir="/tmp/ranger_dir"<CR>')
map('<Leader>fb', '<CMD>Telescope buffers<CR>')
map('<Leader>fd', '<CMD>lua telescope_find_dir()<CR>')
map('<Leader>fhd', '<CMD>lua telescope_find_dir_home()<CR>')
map('<Leader>fp', '<CMD>Telescope neoclip<CR>')
map('<Leader>ft', '<CMD>Telescope termfinder find<CR>')


lmap.f = {
    name = 'find',
    f = 'find-files',
    h = {
        name = 'find-home',
        d = 'find-dir-home',
        f = 'find-files-home',
    },
    g = 'find-git-files',
    c = 'find-code',
    l = 'file-tree',
    r = 'find-ranger',
    d = 'find-directory',
    b = 'find-buffers',
    p = 'find-clipboard',
    t = 'find-term',
}

-- LSP
noremap({'silent'}, '<Leader>ld', lsp.definition)
noremap({'silent'}, '<Leader>lh', lsp.hover)
noremap({'silent'}, '<Leader>ls', lsp.signature_help)
noremap({'silent'}, '<Leader>li', lsp.implementation)
noremap({'silent'}, '<Leader>lr', lsp.references)
noremap({'silent'}, '<Leader>ln', lsp.rename)
nnoremap({'silent'}, '<Leader>la', require('jdtls').code_action)
vnoremap({'silent'}, '<Leader>la', '<CMD>lua require("jdtls").code_action(true)<CR>')
map({'silent'}, '<Leader>lf', 'gf')
nmap({'silent'}, '<Leader>lp', '<CMD>Neoformat<CR>')
--nmap({'silent'}, '<Leader>lp', '<CMD>lua vim.lsp.buf.formatting_sync()<CR>')
map({'silent'}, '<Leader>lee', '<CMD>TroubleToggle<CR>')
noremap({'silent'}, '<Leader>lel', diagnostic.show_line_diagnostics)
noremap({'silent'}, '<Leader>len', diagnostic.goto_next)
noremap({'silent'}, '<Leader>lep', diagnostic.goto_prev)

lmap.l = {
    name = 'lsp',
    h = 'show-hover',
    s = 'show-signature',
    d = 'goto-definition',
    i = 'goto-implementation',
    r = 'goto-references',
    n = 'rename-symbol',
    a = 'code-action',
    f = 'goto-file',
    p = 'prettier-format',
    e = {
        name = 'diagnostics',
        e = 'diagnostic-overview',
        l = 'line-diagnostics',
        n = 'next-diagnostic',
        p = 'prev-diagnostic'
    }
}





map({'silent'}, '<Leader>tf', '<CMD>terminal<CR>')
map({'silent'}, '<Leader>tt', '<Cmd>exe v:count1 . "ToggleTerm"<CR>')

lmap.t = {
    name = 'term',
    t = 'mini-terminal',
    v = 'vertical-terminal',
    h = 'horizontal-terminal',
    f = 'full-terminal'
}


-- Buffers and cwd
map('<Leader>be', '<CMD>enew<CR>')
map('<Leader>bx', '<CMD>close<CR>')
map('<Leader>bc', '<CMD>cd %:p:h<CR>')
map('<Leader>bv', '<CMD>vsplit<CR>')
map('<Leader>bh', '<CMD>split<CR>')
map('<Leader>bo', '<CMD>ZoomWinTabToggle<CR>')
map('<Leader>bt', '<CMD>tabnew<CR>')
map('<Leader>bm', '<CMD>WinShift<CR>')


lmap.b = {
    name = 'buffer',
    d = 'buffer-close',
    e = 'open-empty-buffer',
    x = 'window-close',
    v = 'vertical-split',
    h = 'horizontal-split',
    o = 'maximize-buffer',
    c = 'set-cwd',
    t = 'open-new-tab',
    m = 'buffer-move'
}

-- Git
map('<Leader>gc', '<CMD>Telescope git_commits prompt_prefix=🔍<CR>')
map('<Leader>gb', '<CMD>silent Merginal<CR>')
map('<Leader>gh', '<CMD>Git blame<CR>')
map('<Leader>gm', '<CMD>Git mergetool<CR>')
map('<Leader>gs', '<CMD>Ge :<CR>')
map('<Leader>gv', '<CMD>silent !gh repo view --web<CR>')

map('<Leader>gdo', '<CMD>Gvdiffsplit!<CR>')
map('<Leader>gdh', '<CMD>ConflictMarkerOurselves<CR>')
map('<Leader>gdl', '<CMD>ConflictMarkerThemselves<CR>')
map('<Leader>gdu', '<CMD>diffupdate<CR>')

lmap.g = {
    name = 'git',
    c = 'git-commits',
    b = 'git-branch',
    h = 'git-blame',
    m = 'git-mergetool',
    s = 'git-status',
    v = 'git-browser',

    d = {
        name = 'git-diff',
        o = 'git-diff-vsplit',
        h = 'git-diff-take-ours',
        l = 'git-diff-take-theirs',
        u = 'git-diff-update'
    }
}


-- Help
map({'silent'}, '<Leader>ht', '<CMD>Telescope help_tags prompt_prefix=🔍<CR>')
map({'silent'}, '<Leader>hw', '<CMD>execute "h " . expand("<cword>")<CR>')

lmap.h = {
    name = 'help',
    t = 'help-tags',
    w = 'help-cword'
}

-- Not categorized
noremap('<Leader>no', '<CMD>nohlsearch<CR>')
map('<Leader><BS>', '<CMD>cd ..<CR>')
map('<Leader>w', '<CMD>w<CR>')
map('<Leader><CR>', '<CMD>TermExec go_back=1 cmd="!!"<CR>')

lmap.n = { name = 'leader_ignore', n = 'leader_ignore'}
lmap['<BS>'] = 'leader_ignore'
lmap['<CR>'] = 'leader_ignore'
lmap.s = { name = 'leader_ignore', s = 'leader_ignore'}
lmap.w = 'leader_ignore'

lmap.o = { name = 'neorg'}



-- Startify
map('<Leader>ss', '<CMD>Startify<CR>')

-- Setup Leader Guide
vim.g.lmap = lmap

vim.g.leaderGuide_display_plus_menus = 1
vim.g.leaderGuide_vertical = 0
vim.g.leaderGuide_position = 'botleft'
vim.g.leaderGuide_hspace = 5

vimscript('call leaderGuide#register_prefix_descriptions("<Space>", "g:lmap")', false)
vimscript("nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>", false)
