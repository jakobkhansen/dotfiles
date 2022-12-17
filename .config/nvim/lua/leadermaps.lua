local wk = require("which-key")

vim.g.mapleader = " "

local utils = require("utils")
local term = require("terminal")

local lsp = vim.lsp.buf
local diagnostic = vim.diagnostic
-- local fzf_custom = require("plugins.fzf-config")
local telescope_custom = require("plugins.telescope-config")
local commands = require("commands")

wk.register({
    f = {
        name = "find",
        -- f = { fzf.files, "find-files" }, Microsoft
        f = { "<CMD>Telescope find_files<CR>", "find-files" },
        d = { telescope_custom.find_any, "find-directory" },
        g = { "<CMD>Telescope git_files<CR>", "find-git" },
        r = {
            function()
                term.openFloatTerm("ranger")
            end,
            "find-ranger",
        },
        l = { "<CMD>Neotree reveal toggle<CR>", "file-browser" },
        o = { "<CMD>Telescope oldfiles<CR>", "find-mru" },

        c = {
            "<CMD>Telescope live_grep<CR>",
            "find-code",
        },

        p = { "<CMD>Telescope neoclip<CR>", "find-clipboard" },
        b = { "<CMD>Telescope buffers<CR>", "find-buffers" },
        j = { "<CMD>Telescope jumplist<CR>", "find-jump" },
    },

    -- Buffer
    b = {
        name = "buffer",
        d = { "<CMD>lua MiniBufremove.wipeout(0, true)<CR>", "buffer-close" },
        e = { "<CMD>enew<CR>", "open-empty-buffer" },
        x = { "<CMD>close<CR>", "window-close" },
        v = { "<CMD>vsplit<CR>", "vertical-split" },
        h = { "<CMD>split<CR>", "horizontal-split" },
        t = { "<CMD>tabnew<CR>", "tab-new" },
    },

    -- LSP
    l = {
        name = "lsp",
        d = { "<CMD>Telescope lsp_definitions<CR>", "goto-definition" },
        h = { lsp.hover, "show-hover" },
        s = { lsp.signature_help, "show-signature" },
        r = { "<CMD>Telescope lsp_references<CR>", "goto-references" },
        t = { "<CMD>Telescope lsp_type_definitions<CR>", "goto-type-definition" },
        x = { "<CMD>LspRestart<CR>", "lsp-restart" },
        m = {
            name = "debug, master",
            i = { "<CMD>LspInfo<CR>", "lsp-info" },
            l = { "<CMD>e ~/.local/state/nvim/lsp.log<CR>", "lsp-log" },
        },
        i = { "<CMD>Telescope lsp_implementations<CR>", "lsp-info" },
        n = { lsp.rename, "rename-symbol" },
        a = { lsp.code_action, "code-actions" },
        p = { lsp.formatting, "lsp-format" },
        e = {
            name = "diagnostics",
            e = { "<CMD>Telescope diagnostics<CR>", "diagnostic-overview" },
            l = { diagnostic.open_float, "line-diagnostics" },
            n = { diagnostic.goto_next, "goto-next" },
            p = { diagnostic.goto_prev, "goto-prev" },
        },
    },

    -- Terminal
    t = {
        name = "terminal",
        t = { term.openPopupTerminal, "popup-terminal" },
        f = { term.openFullTerminal, "full-terminal" },
        h = { term.openFloatTerm, "float-terminal" },
    },

    -- Git
    g = {
        name = "git",
        s = { "<CMD>Ge :<CR>", "git-status" },
        c = { "<CMD>Telescope git_commits<CR>", "git-commits" },
        b = { "<CMD>Telescope git_branches<CR>", "git-branches" },
        d = { "<CMD>DiffviewOpen main...HEAD<CR>", "git-diffview" },
        h = {
            name = "hunk",
            p = { "<CMD>Gitsigns preview_hunk<CR>", "hunk-preview" },
            s = { "<CMD>Gitsigns stage_hunk<CR>", "hunk-stage" },
            n = { "<CMD>Gitsigns next_hunk<CR>", "hunk-next" },
            r = { "<CMD>Gitsigns reset_hunk<CR>", "hunk-reset" },
        },
    },

    -- Path, cwd, session
    p = {
        name = "path, cwd, session",
        p = { "<CMD>pwd<CR>", "pwd" },
        f = { "<CMD>echo @%<CR>", "file-path" },
        h = { "<CMD>cd $HOME<CR>", "path-home" },
        g = { utils.CWDgitRoot, "path-git-root" },
        n = { "<CMD>cd $HOME/.config/nvim<CR>", "path-neovim-config" },
        c = { "<CMD>cd %:p:h<CR><CMD>pwd<CR>", "path-current-file" },
        o = { "<CMD>cd $HOME/Documents/gtd<CR>", "path-gtd" },
        s = {
            name = "session",
            s = {
                "<CMD>Session<CR>",
                "session-save",
            },
            r = {
                "<CMD>SessionRestore<CR>",
                "session-restore",
            },
        },
    },

    -- Neorg
    o = {
        name = "organize",
        h = {
            "<CMD>silent! NeorgStart<CR><CMD>Neorg journal custom " .. utils.getFirstDayOfCurrentMonth() .. "<CR>",
            "hours",
        },
        j = { "<CMD>silent! NeorgStart<CR><CMD>Neorg journal today<CR>", "journal" },
        p = { "<CMD>edit $HOME/Documents/gtd/projects.norg<CR>", "projects" },
    },

    -- Shortcuts
    s = {
        name = "shortcuts",
        s = { "<CMD>Alpha<CR>", "start-screen" },
        t = { commands.ToggleThemeMode, "toggle-theme" },
        b = { commands.ToggleTabLine, "toggle-tabline" },
    },

    -- Help
    h = {
        name = "help",
        t = { "<CMD>Telescope help_tags<CR>", "help-tags" },
        w = { '<CMD>execute "h " . expand("<cword>")<CR>', "help-cword" },
    },

    -- Uncategorized
    w = { "<CMD>echo<CR><CMD>silent w<CR>", "which_key_ignore" },
    ["<BS>"] = { "<CMD>cd ..<CR><CMD>pwd<CR>", "which_key_ignore" },
    ["<CR>"] = {
        function()
            term.execInPopupTerminal("!!\n")
        end,
        "which_key_ignore",
    },
}, { prefix = "<Leader>" })

wk.register({
    l = {
        name = "lsp",
        a = { "<CMD>lua vim.lsp.buf.code_action()<CR>", "code-actions" },
    },
}, { prefix = "<Leader>", mode = "v" })
