require("focus").setup({
    enable = true,
    commands = true,
    autoresize = {
        enable = true,
        width = 0,
        height = 0,
        minwidth = 40,
        minheight = 0,
        focusedwindow_minwidth = 0,
        focusedwindow_minheight = 0,
        height_quickfix = 10,
        equalise_min_cols = 0,
        equalise_min_rows = 0,
    },
    split = {
        bufnew = false,
        tmux = false,
    },
    ui = {
        number = false,
        relativenumber = false,
        hybridnumber = false,
        absolutenumber_unfocussed = false,

        cursorline = false,
        cursorcolumn = false,
        colorcolumn = {
            enable = false,
            list = '+1',
        },
        signcolumn = true,
        winhighlight = false,
    }
})

local ignore_filetypes = { 'neo-tree' }
local ignore_buftypes = { 'nofile', 'prompt', 'popup' }

local augroup =
    vim.api.nvim_create_augroup('FocusDisable', { clear = true })

vim.api.nvim_create_autocmd('WinEnter', {
    group = augroup,
    callback = function(_)
        if vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
        then
            vim.w.focus_disable = true
        else
            vim.w.focus_disable = false
        end
    end,
    desc = 'Disable focus autoresize for BufType',
})

vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    callback = function(_)
        if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.b.focus_disable = true
        else
            vim.b.focus_disable = false
        end
    end,
    desc = 'Disable focus autoresize for FileType',
})
