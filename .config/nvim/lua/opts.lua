local opt = vim.opt
local call = vim.call
local vimscript = vim.api.nvim_exec
local highlight = vim.highlight.create

-- Vim options
vimscript("filetype plugin indent on", false)
vimscript("au FileType * setlocal fo-=c fo-=r fo-=o", false)


opt.smartindent = true
opt.autoindent = true
opt.expandtab = true

-- Tabstop: Number of space in a <Tab>
opt.tabstop = 4

-- Shiftwidth: Number of spaces in an indentation
opt.shiftwidth = 4

-- Softtabstop: How many columns is a <Tab> or <BS>
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

vim.g.tokyonight_transparent_sidebar = true
vim.g.tokyonight_colors = {
    info = "#FFFFFF",
    hint = "#FFFFFF",
}
vim.g.tokyonight_italic_keywords = false
vim.g.tokyonight_italic_comments = false
vimscript("colorscheme tokyonight", false)

highlight('BufferLineFill', {guibg="NONE", ctermbg="NONE"}, false)



-- LightMode command
function _G.LightMode()
    require('github-theme').setup({
        theme_style = "light",
        dark_sidebar = false,
        hide_end_of_buffer = true
    })
end

function _G.DarkMode()
    vimscript("colorscheme tokyonight", false)
    opt.background = 'dark'
    vim.api.nvim_command('AirlineTheme tokyonight')
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
vim.g.bclose_no_plugin_maps = true
