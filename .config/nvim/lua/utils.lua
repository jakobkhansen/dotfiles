local command = vim.api.nvim_command

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

-- Tables, arrays
function P.isArray(t)
    if type(t) ~= "table" then
        return false
    end
    local i = 0
    for _ in pairs(t) do
        i = i + 1
        if t[i] == nil then
            return false
        end
    end
    return true
end

-- OS handling
function P.isUnix()
    return vim.fn.has("macunix") ~= 0
end

function P.isWindows()
    return vim.fn.has("win32") ~= 0
end

function P.grepWordUnderCursor()
    local word = vim.fn.expand("<cword>")
    Snacks.picker.grep({ search = word })
end

return P
