local vimscript = vim.api.nvim_exec
local utils = require("utils")

local P = {}
-- Terminals
function P.openFullTerminal(cmd)
    local buf = vim.api.nvim_create_buf(true, false)
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)

    local on_exit = function()
        vim.api.nvim_buf_delete(buf, { force = true })
    end

    vim.api.nvim_command("startinsert")
    vim.fn.termopen(cmd or vim.o.shell, {
        on_exit = on_exit,
    })
end

local popUpBuffer = nil
local popUpWindow = nil
local popUpJobId = nil

function P.openPopupTerminal(cmd)
    -- Create window if it doesn't exist
    if not utils.windowExists(popUpWindow) then
        vim.cmd("bot 15sp")
        popUpWindow = vim.api.nvim_get_current_win()
    end

    if popUpBuffer ~= nil then
        vim.api.nvim_set_current_win(popUpWindow)
        vim.api.nvim_win_set_buf(popUpWindow, popUpBuffer)
        return
    end

    popUpBuffer = vim.api.nvim_create_buf(true, false)

    vim.api.nvim_win_set_buf(popUpWindow, popUpBuffer)
    vim.cmd("set nobl")

    local on_exit = function()
        vim.api.nvim_buf_delete(popUpBuffer, { force = true })
        vim.api.nvim_win_close(popUpWindow, true)
        popUpBuffer = nil
        popUpWindow = nil
    end

    vim.api.nvim_command("startinsert")
    popUpJobId = vim.fn.termopen(cmd or vim.o.shell, {
        on_exit = on_exit,
    })
end

function P.clearPopupTerminal()
    popUpBuffer = nil
    popUpWindow = nil
    popUpJobId = nil
end

function P.execInTerminal(cmd, job)
    vim.fn.chansend(job, cmd)
end

function P.execInPopupTerminal(cmd)
    if utils.windowExists(popUpWindow) then
        vim.fn.chansend(popUpJobId, cmd)
    end
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
    vim.fn.termopen(cmd or vim.o.shell, {
        on_exit = on_exit,
    })
end

return P
