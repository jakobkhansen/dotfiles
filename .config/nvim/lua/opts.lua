local opt = vim.opt
local vimscript = vim.api.nvim_exec
local autocmd = vim.api.nvim_create_autocmd

-- Vim options
opt.smartindent = true
opt.expandtab = true

-- Tabstop: Number of space in a <Tab>
opt.tabstop = 4

-- Shiftwidth: Number of spaces in an indentation
opt.shiftwidth = 4

-- Softtabstop: How many columns is a <Tab> or <BS>
opt.softtabstop = 4

opt.textwidth = 90

-- Buffers
opt.splitright = true
opt.splitbelow = true

-- Random
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.wrap = false
opt.smartcase = true
opt.ignorecase = true
opt.scrolloff = 5
opt.timeoutlen = 300
opt.foldenable = false

-- Don't auto-create comments on new-line
autocmd("FileType", {
    pattern = "*",
    command = "setlocal fo-=c fo-=r fo-=o",
})

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10

-- Visuals
opt.signcolumn = "yes:1"
vim.opt.laststatus = 3
vim.opt.statusline = " "
vim.opt.cmdheight = 0

-- opt.ruler = false

-- Better diffline
vimscript("set diffopt+=linematch:60", false)

-- Persistent undo
local undoDir = "/tmp/.undodir_" .. vim.env["USER"]
if not vim.fn.isdirectory(undoDir) then
    vim.fn.mkdir(undoDir, "", 0700)
end
opt.undodir = undoDir
opt.undofile = true

-- Swap files
opt.swapfile = false

-- Netrw
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_list_hide = "^\\..*"
vim.g.netrw_hide = 1
vim.g.netrw_keepdir = 0
