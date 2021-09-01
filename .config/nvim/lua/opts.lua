local opt = vim.opt
local call = vim.call
local vimscript = vim.api.nvim_exec
local highlight = vim.highlight.create

-- Vim options


-- call("filetype plugin indent on")

vimscript("filetype plugin indent on", false)
vimscript("au FileType * setlocal fo-=c fo-=r fo-=o", false)

opt.smartindent = true
opt.autoindent = true
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tw = 90


-- Buffers
opt.hidden = true
opt.splitright = true
opt.splitbelow = true

-- Random
opt.number = true opt.wrap = false
opt.smartcase = true
opt.ignorecase = true
opt.mouse = 'a'
opt.scrolloff = 10
opt.relativenumber = true
opt.timeoutlen = 300
opt.foldmethod = 'indent'
opt.foldlevel = 99

-- Completion
opt.completeopt='menuone,noselect'
opt.pumheight = 10

-- Visuals
opt.termguicolors = true
opt.signcolumn = 'yes:1'

vim.g.tokyonight_transparent = true
vim.g.tokyonight_transparent_sidebar = true
--vim.g.tokyonight_style = "day"
vim.g.tokyonight_colors = {
    info = "#FFFFFF",
    hint = "#FFFFFF"
}
vim.g.tokyonight_italic_keywords = false
vim.g.tokyonight_italic_comments = false
vimscript("colorscheme tokyonight", false)


-- Background
highlight('Normal', {guibg="NONE", ctermbg="NONE"}, false)
highlight('SignColumn', {guibg="NONE", ctermbg="NONE"}, false)

-- LightMode command
function _G.LightMode()
    vimscript("colorscheme solarized-low", false)
    opt.background = 'light'
end

function _G.DarkMode()
    vimscript("colorscheme tokyonight", false)
    opt.background = 'dark'
end

vimscript('command! LightMode :lua LightMode()', false)
vimscript('command! DarkMode :lua DarkMode()', false)

-- Remove spelling mistake highlight
vimscript("hi clear SpellBad", false)
vimscript("hi clear SpellCap", false)
vimscript("hi clear SpellRare", false)
vimscript("hi clear SpellLocal", false)


-- Persistent undo
local undoDir = "/tmp/.undodir_" .. vim.env['USER']
if not vim.fn.isdirectory(undoDir) then
    vim.fn.mkdir(undoDir, "", 0700)
end
opt.undodir = undoDir
opt.undofile = true

-- Swap files
opt.swapfile = false

-- Disable default mappings

vim.g.bclose_no_plugin_maps = false
