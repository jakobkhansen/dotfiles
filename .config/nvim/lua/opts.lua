local opt = vim.opt
local vimscript = vim.api.nvim_exec
local autocmd = vim.api.nvim_create_autocmd
local utils = require("utils")

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
opt.foldenable = false

-- Don't auto-create comments on new-line
autocmd("FileType", {
    pattern = "*",
    command = "setlocal fo-=c fo-=r fo-=o",
})

-- Completion
opt.pumheight = 10

-- Visuals
opt.signcolumn = "yes:1"
vim.opt.laststatus = 3
vim.opt.statusline = " "
vim.opt.ruler = false

-- opt.ruler = false

-- Better diffline
vimscript("set diffopt+=linematch:60", false)

-- Persistent undo
local undoDir = "/tmp/.vim_undodir"
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

-- Terminal
if utils.isWindows() then
    vim.o.shell = "pwsh"
    vim.o.shellcmdflag =
    '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[\'Out-File:Encoding\']=\'utf8\';Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
    vim.o.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
    vim.o.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
end
