local vimscript = vim.api.nvim_exec
local utils = require("utils")
local P = {}
local lastOpenedTerminalJobId = nil

-- Terminals
function P.openFullTerminal(cmd)
    local buf = vim.api.nvim_create_buf(true, false)
    local win = vim.api.nvim_get_current_win()
    vim.bo[buf].filetype = "terminal"
    vim.api.nvim_win_set_buf(win, buf)

    local on_exit = function()
        vim.api.nvim_buf_delete(buf, { force = true })
    end

    vim.api.nvim_command("startinsert")
    lastOpenedTerminalJobId = vim.fn.termopen(cmd or vim.o.shell, {
        on_exit = on_exit,
    })
end

function P.openPopupTerminal(cmd)
    -- Create window if it doesn't exist
    vim.cmd("bot 15sp")
    local popUpWindow = vim.api.nvim_get_current_win()

    local popUpBuffer = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_win_set_buf(popUpWindow, popUpBuffer)

    local on_exit = function()
        vim.api.nvim_win_close(popUpWindow, true)
        lastOpenedTerminalJobId = nil
    end

    vim.api.nvim_command("startinsert")
    lastOpenedTerminalJobId = vim.fn.termopen(cmd or vim.o.shell, {
        on_exit = on_exit,
    })
end

function P.execInTerminal(cmd, job)
    vim.fn.chansend(job, cmd)
end

function P.execInPopupTerminal(cmd)
    vim.fn.chansend(lastOpenedTerminalJobId, cmd)
end

function P.openFloatTerm(cmd)
    local buf = vim.api.nvim_create_buf(false, true)
    local win_height = math.ceil(vim.api.nvim_get_option("lines") * 0.8 - 4)
    local win_width = math.ceil(vim.api.nvim_get_option("columns") * 0.8)
    local col = math.ceil((vim.api.nvim_get_option("columns") - win_width) * 0.5)
    local row = math.ceil((vim.api.nvim_get_option("lines") - win_height) * 0.5 - 1)
    local opts = {
        style = "minimal",
        relative = "editor",
        border = "rounded",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
    }
    local win = vim.api.nvim_open_win(buf, true, opts)

    local on_exit = function()
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, { force = true })
    end

    vim.api.nvim_command("startinsert")
    lastOpenedTerminalJobId = vim.fn.termopen(cmd or vim.o.shell, {
        on_exit = on_exit,
    })
end

return P
