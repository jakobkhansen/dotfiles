local M = {}

require("fzf-lua").setup({
    winopts = {
        -- split         = "belowright new",-- open in a split instead?
        -- "belowright new"  : split below
        -- "aboveleft new"   : split above
        -- "belowright vnew" : split right
        -- "aboveleft vnew   : split left
        -- Only valid when using a float window
        -- (i.e. when 'split' is not defined, default)
        height = 0.90, -- window height
        width = 0.90, -- window width
        row = 0.35, -- window row position (0=top, 1=bottom)
        col = 0.50, -- window col position (0=left, 1=right)
        -- border argument passthrough to nvim_open_win(), also used
        -- to manually draw the border characters around the preview
        -- window, can be set to 'false' to remove all borders or to
        -- 'none', 'single', 'double', 'thicc' or 'rounded' (default)
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        fullscreen = false, -- start fullscreen?
        -- highlights should optimally be set by the colorscheme using
        -- FzfLuaXXX highlights. If your colorscheme doesn't set these
        -- or you wish to override its defaults use these:
    },
    preview = {
        -- default     = 'bat',           -- override the default previewer?
        -- default uses the 'builtin' previewer
        border = "border", -- border|noborder, applies only to
        -- native fzf previewers (bat/cat/git/etc)
        wrap = "nowrap", -- wrap|nowrap
        hidden = "hidden", -- hidden|nohidden
        vertical = "down:45%", -- up|down:size
        horizontal = "right:40%", -- right|left:size
        layout = "flex", -- horizontal|vertical|flex
        flip_columns = 120, -- #cols to switch to horizontal on flex
        -- Only used with the builtin previewer:
        title = true, -- preview border title (file/buf)?
        scrollbar = "float", -- `false` or string:'float|border'
        -- float:  in-window floating border
        -- border: in-border chars (see below)
        scrolloff = "-2", -- float scrollbar offset from right
        -- applies only when scrollbar = 'float'
        scrollchars = { "█", "" }, -- scrollbar chars ({ <full>, <empty> }
        -- applies only when scrollbar = 'border'
        delay = 100, -- delay(ms) displaying the preview
        -- prevents lag on fast scrolling
        winopts = { -- builtin previewer window options
            number = true,
            relativenumber = false,
            cursorline = true,
            cursorlineopt = "both",
            cursorcolumn = false,
            signcolumn = "no",
            list = false,
            foldenable = false,
            foldmethod = "manual",
        },
    },
    fzf_opts = {
        -- options are sent as `<left>=<right>`
        -- set to `false` to remove a flag
        -- set to '' for a non-value flag
        -- for raw args use `fzf_args` instead
        ["--layout"] = "default",
    },
    keymap = {
        -- These override the default tables completely
        -- no need to set to `false` to disable a bind
        -- delete or modify is sufficient
        builtin = {
            -- neovim `:tmap` mappings for the fzf win
            ["<F1>"] = "toggle-help",
            ["<F2>"] = "toggle-fullscreen",
            -- Only valid with the 'builtin' previewer
            ["<F3>"] = "toggle-preview-wrap",
            ["<F4>"] = "toggle-preview",
            -- Rotate preview clockwise/counter-clockwise
            ["<F5>"] = "toggle-preview-ccw",
            ["<F6>"] = "toggle-preview-cw",
            ["<S-down>"] = "preview-page-down",
            ["<S-up>"] = "preview-page-up",
            ["<S-left>"] = "preview-page-reset",
        },
        fzf = {
            -- fzf '--bind=' options
            ["ctrl-z"] = "abort",
            ["ctrl-u"] = "unix-line-discard",
            ["ctrl-f"] = "half-page-down",
            ["ctrl-b"] = "half-page-up",
            ["ctrl-a"] = "beginning-of-line",
            ["ctrl-e"] = "end-of-line",
            ["alt-a"] = "toggle-all",
            -- Only valid with fzf previewers (bat/cat/git/etc)
            ["f3"] = "toggle-preview-wrap",
            ["f4"] = "toggle-preview",
            ["shift-down"] = "preview-page-down",
            ["shift-up"] = "preview-page-up",
        },
    },
    file_icon_padding = " ",
})

M.fzf_dirs = function(opts)
    local fzf_lua = require("fzf-lua")
    opts = opts or {}
    opts.prompt = "Directories> "
    opts.fn_transform = function(x)
        return fzf_lua.utils.ansi_codes.magenta(x)
    end
    opts.actions = {
        ["default"] = function(selected)
            vim.cmd("cd " .. selected[1])
        end,
    }
    fzf_lua.fzf_exec("fd --type d --hidden", opts)
end

return M
