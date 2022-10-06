local command = vim.api.nvim_command
local vimscript = vim.api.nvim_exec

local P = {}

-- Path and files
function P.CWDgitRoot()
    local cwd = vim.loop.cwd()
    local git_root = require("lspconfig").util.root_pattern(".git")(cwd)

    if git_root ~= nil then
        local cd_command = "cd " .. git_root
        command(cd_command)
    else
        print("Not a git repository")
    end
end

function P.isFileOrDir(path)
    local p = io.popen(("file %q"):format(path))
    if p then
        local out = p:read():gsub("^[^:]-:%s*(%w+).*", "%1")
        p:close()
        return out
    end
end

-- Dates
function P.getFirstDayOfCurrentMonth()
    return os.date("%Y") .. "-" .. os.date("%m") .. "-01"
end

-- Windows, buffers
function P.windowExists(win)
    local windows = vim.api.nvim_list_wins()
    for i, window in ipairs(windows) do
        if window == win then
            return true
        end
    end

    return false
end

function P.bufExists(buf)
    local bufs = vim.api.nvim_list_bufs()
    for i, buffer in ipairs(bufs) do
        if buffer == buf then
            return true
        end
    end

    return false
end

return P
