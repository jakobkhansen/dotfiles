local utils = require("utils")
local term = require("terminal")

local lsp = vim.lsp.buf
local diagnostic = vim.diagnostic
local telescope_custom = require("telescope-config")
local commands = require("commands")
local dap = require("dap")
local dapwidgets = require("dap.ui.widgets")

vim.g.mapleader = " "

local mappings = {
    f = {
        f = { "<CMD>Telescope find_files previewer=false<CR>", "find-files" },
        d = { telescope_custom.find_dir, "find-directory" },
        g = {
            function()
                require("telescope.builtin").git_files({
                    git_command = { "git", "ls-files", "--sparse", "--cached", "[^ooui]*" },
                    previewer = false,
                })
            end,
            "find-git",
        },
        r = {
            function()
                term.openFloatTerm("ranger")
            end,
            "find-ranger",
        },
        t = { "<CMD>Neotree reveal toggle<CR>", "file-browser" },
        o = { "<CMD>Telescope oldfiles previewer=false<CR>", "find-mru" },

        c = {
            "<CMD>Telescope live_grep<CR>",
            "find-code",
        },

        p = { "<CMD>Telescope neoclip<CR>", "find-clipboard" },
        j = { "<CMD>Telescope jumplist<CR>", "find-jump" },
    },
    -- Buffer
    b = {
        b = { "<CMD>lua MiniBufremove.wipeout(0, true)<CR>", "buffer-close" },
        e = { "<CMD>enew<CR>", "open-empty-buffer" },
        q = { "<CMD>close<CR>", "window-close" },
        v = { "<CMD>vsplit<CR>", "vertical-split" },
        s = { "<CMD>vsplit<CR>", "vertical-split" },
        h = { "<CMD>split<CR>", "horizontal-split" },
        t = { "<CMD>tabnew<CR>", "tab-new" },
    },
    -- LSP
    l = {
        d = { "<CMD>Telescope lsp_definitions<CR>", "goto-definition" },
        h = { lsp.hover, "show-hover" },
        s = { lsp.signature_help, "show-signature" },
        r = { "<CMD>Telescope lsp_references<CR>", "goto-references" },
        t = { "<CMD>Telescope lsp_type_definitions<CR>", "goto-type-definition" },
        w = { "<CMD>Telescope lsp_workspace_symbols<CR>", "workspace-symbols" },
        x = { "<CMD>LspRestart<CR>", "lsp-restart" },
        i = { "<CMD>Telescope lsp_implementations<CR>", "lsp-info" },
        n = { lsp.rename, "rename-symbol" },
        a = { lsp.code_action, "code-actions" },
        p = { lsp.format, "lsp-format" },
        -- Diagnostics
    },
    -- Diagnostics
    e = {
        e = { "<CMD>Telescope diagnostics<CR>", "diagnostic-overview" },
        l = { diagnostic.open_float, "line-diagnostics" },
        n = { diagnostic.goto_next, "goto-next" },
        p = { diagnostic.goto_prev, "goto-prev" },
    },
    -- Terminal
    t = {
        t = { term.openPopupTerminal, "popup-terminal" },
        f = { term.openFullTerminal, "full-terminal" },
        h = { term.openFloatTerm, "float-terminal" },
    },
    -- Git
    g = {
        s = { "<CMD>Ge :<CR>", "git-status" },
        c = { "<CMD>Telescope git_commits<CR>", "git-commits" },
        b = { "<CMD>Telescope git_branches<CR>", "git-branches" },
        d = { "<CMD>DiffviewOpen main...HEAD<CR>", "git-diffview" },
        o = { "<CMD>silent !gitopen %<CR>", "git-open" },
        -- Hunks
        h = {
            p = { "<CMD>Gitsigns preview_hunk<CR>", "hunk-preview" },
            s = { "<CMD>Gitsigns stage_hunk<CR>", "hunk-stage" },
            n = { "<CMD>Gitsigns next_hunk<CR>", "hunk-next" },
            r = { "<CMD>Gitsigns reset_hunk<CR>", "hunk-reset" },
        },
    },

    -- Debug / test
    d = {
        f = { "<CMD>Neotest run file<CR>", "test-file" },
        t = { require("neotest").run.run, "test-nearest" },
        s = { "<CMD>Neotest summary<CR>", "test-summary" },
        o = { "<CMD>Neotest output<CR>", "test-output" },
        b = { dap.toggle_breakpoint, "toggle-breakpoint" },
        h = { dapwidgets.hover, "debug-hover" },
        c = { dap.continue, "debug-continue" },
        n = { dap.step_over, "debug-continue" },
    },
    -- Path, cwd, session
    p = {
        p = { "<CMD>pwd<CR>", "pwd" },
        f = { "<CMD>echo @%<CR>", "file-path" },
        h = { "<CMD>cd $HOME<CR>", "path-home" },
        g = { utils.CWDgitRoot, "path-git-root" },
        n = { "<CMD>cd $HOME/.config/nvim<CR>", "path-neovim-config" },
        c = { "<CMD>cd %:p:h<CR><CMD>pwd<CR>", "path-current-file" },
        o = { "<CMD>cd $HOME/Documents/gtd<CR>", "path-gtd" },
        -- Sessions
        s = {
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
    -- Organize, notes, etc
    j = {
        d = { "<CMD>Journal<CR>", "daily-journal" },
        w = { "<CMD>Journal week<CR>", "weekly-journal" },
    },
    -- Shortcuts
    s = {
        s = { "<CMD>Alpha<CR>", "start-screen" },
        t = { commands.ToggleThemeMode, "toggle-theme" },
        b = { commands.ToggleTabLine, "toggle-tabline" },
    },
    -- Help
    h = {
        t = { "<CMD>Telescope help_tags<CR>", "help-tags" },
        w = { '<CMD>execute "h " . expand("<cword>")<CR>', "help-cword" },
        k = { "<CMD>Telescope keymaps<CR>", "help-keymaps" },
    },
    -- Uncategorized
    w = { "<CMD><CR><CMD>silent w<CR>", "write" },
    z = { "ZZ" },
    q = { "<CMD>q<CR>" },
    ["<BS>"] = { "<CMD>cd ..<CR><CMD>pwd<CR>", "cd .." },
    ["<CR>"] = {
        function()
            vim.cmd("wa")
            term.execInPopupTerminal("!!\n")
        end,
        "Term exec last command",
    },
}

local visual_mappings = {
    p = { '"_dP', "Paste without register overwrite" },
    l = {
        a = { lsp.code_action, "code-actions" },
    },
}

-- Manually register mappings without which-key
function _G.registerMappings(keymap, rec_mappings, mode)
    if utils.isArray(rec_mappings) then
        if type(rec_mappings[1]) == "string" then
            vim.keymap.set(mode, keymap, rec_mappings[1], { desc = rec_mappings[2] })
        elseif type(rec_mappings[1]) == "function" then
            vim.keymap.set(mode, keymap, "", { desc = rec_mappings[2], callback = rec_mappings[1] })
        end
        return
    end

    for key, _ in pairs(rec_mappings) do
        registerMappings(keymap .. key, rec_mappings[key], mode)
    end
end

registerMappings("<Leader>", mappings, "n")
registerMappings("<Leader>", visual_mappings, "v")
