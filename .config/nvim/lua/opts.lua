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
opt.numberwidth = 1

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
opt.updatetime = 2000

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

vim.o.shellcmdflag = "-ic"

-- cmdline
opt.cmdheight = 0
require("vim._core.ui2").enable({
    enable = true
})

-- Enable autoread and set up checking triggers
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    command = "if mode() != 'c' | checktime | endif",
    pattern = "*",
})

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

-- Quickfix list
autocmd('FileType', {
    pattern = 'qf',
    desc = 'Attach keymaps for quickfix list',
    callback = function()
        vim.keymap.set('n', 'dd', function()
            local qf_list = vim.fn.getqflist()

            local current_line_number = vim.fn.line('.')

            table.remove(qf_list, current_line_number)

            vim.fn.setqflist(qf_list, 'r')

            vim.fn.cursor(current_line_number, 1)
        end, {
            buffer = true,
            silent = true,
            desc = 'Remove quickfix item under cursor',
        })

        vim.keymap.set('v', 'd', function()
            local qf_list = vim.fn.getqflist()
            local first_line = vim.fn.line('v')
            local last_line = vim.fn.line('.')

            -- Normalize order in case selection was made upward
            if first_line > last_line then
                first_line, last_line = last_line, first_line
            end

            -- Remove from bottom to top so indices don't shift
            for i = last_line, first_line, -1 do
                if qf_list[i] then
                    table.remove(qf_list, i)
                end
            end

            vim.fn.setqflist(qf_list, 'r')

            -- Exit visual mode and reposition cursor
            vim.api.nvim_input('<Esc>')
            vim.fn.cursor(first_line, 1)
        end, {
            buffer = true,
            silent = true,
            desc = 'Remove selected quickfix items',
        })
    end
})
