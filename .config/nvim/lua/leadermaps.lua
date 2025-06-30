local utils = require("utils")
local term = require("terminal")

local lsp = vim.lsp.buf
local diagnostic = vim.diagnostic
local commands = require("commands")
local dap = require("dap")
local dapwidgets = require("dap.ui.widgets")

vim.g.mapleader = " "

local mappings = {
    f = {
        f = { function()
            Snacks.picker.files({
                transform = function(item)
                    if (string.match(item.file, '_strings.json')) then
                        return false
                    end
                    return true
                end
            })
        end, "find-files" },
        s = {
            function()
                Snacks.picker.smart({
                    hidden = true,
                    args = { "--type", "d" },
                    transform = function(item)
                        if (string.match(item.file, '_strings.json')) then
                            return false
                        end
                        return true
                    end

                })
            end, "find-smart",
        },
        d = {
            function()
                Snacks.picker.files({
                    args = { "--type", "d" },
                    transform = function(item)
                        if (string.match(item.file, '^.+/$')) then
                            return true
                        end
                        return false
                    end
                })
            end, "find-smart"
        },
        g = {
            function()
                Snacks.picker.git_files({

                    transform = function(item)
                        if (string.match(item.file, '_strings.json')) then
                            return false
                        end
                        return true
                    end
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
        t = { "<CMD>Neotree reveal toggle reveal_force_cwd<CR>", "file-browser" },
        o = { Snacks.picker.recent, "find-mru" },
        c = {
            Snacks.picker.grep,
            "find-code",
        },
        p = {
            Snacks.picker.projects,
            "find-project"
        }
    },
    -- Buffer
    b = {
        b = { "<CMD>vsplit<CR>", "vertical-split" },
        e = { "<CMD>enew<CR>", "open-empty-buffer" },
        q = { "<CMD>close<CR>", "window-close" },
        v = { "<CMD>vsplit<CR>", "vertical-split" },
        h = { "<CMD>split<CR>", "horizontal-split" },
    },
    -- LSP
    l = {
        d = { Snacks.picker.lsp_definitions, "goto-definition" },
        r = { Snacks.picker.lsp_references, "goto-references" },
        t = { Snacks.picker.lsp_type_definitions, "goto-type-definition" },
        w = { Snacks.picker.lsp_workspace_symbols, "workspace-symbols" },
        i = { Snacks.picker.lsp_implementations, "lsp-info" },
        n = { lsp.rename, "rename-symbol" },
        a = { lsp.code_action, "code-actions" },
        p = { lsp.format, "lsp-format" },
        h = { lsp.hover, "show-hover" },
        s = { lsp.signature_help, "show-signature" },
        x = { "<CMD>LspRestart<CR>", "lsp-restart" },
        -- Diagnostics
    },
    -- Diagnostics
    e = {
        e = { Snacks.picker.diagnostics, "diagnostic-overview" },
        l = { diagnostic.open_float, "line-diagnostics" },
        n = { diagnostic.goto_next, "goto-next" },
        p = { diagnostic.goto_prev, "goto-prev" },
    },
    -- Terminal and tabs
    t = {
        t = { term.openPopupTerminal, "popup-terminal" },
        f = { term.openFullTerminal, "full-terminal" },
        h = { term.openFloatTerm, "float-terminal" },
        n = { "<CMD>tabnew<CR>", "tab-new" },
        x = { ":1tabnext<CR>", "tab-1" },
        c = { ":2tabnext<CR>", "tab-2" },
        d = { ":3tabnext<CR>", "tab-3" },
    },
    -- Git
    g = {
        s = { "<CMD>Neogit<CR>", "git-status" },
        c = { Snacks.picker.git_log, "git-commits" },
        b = { Snacks.picker.git_branches, "git-branches" },
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
    },
    -- Organize, notes, etc
    j = {
        d = { "<CMD>Journal<CR>", "daily-journal" },
        w = { "<CMD>Journal week<CR>", "weekly-journal" },
    },
    -- Shortcuts
    s = {
        t = { commands.ToggleThemeMode, "toggle-theme" },
    },
    -- Help
    h = {
        t = { Snacks.picker.help, "help-tags" },
        w = { '<CMD>execute "h " . expand("<cword>")<CR>', "help-cword" },
        k = { Snacks.picker.keymaps, "help-keymaps" },
    },
    -- Uncategorized
    y = { "<CMD>Lazy show<CR>", "lazy" },
    w = { "<CMD><CR><CMD>silent w<CR>", "write" },
    x = { "<CMD>lua MiniBufremove.wipeout(0, true)<CR>", "buffer-close" },
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
