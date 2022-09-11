local command = vim.api.nvim_command
local vimscript = vim.api.nvim_exec
local add_command = vim.api.nvim_create_user_command

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

-- Theme
function P.LightMode()
    command("silent !kitty +kitten themes --reload-in=all Tokyo Night Day")
    vim.o.background = "light"
    vimscript("colorscheme tokyonight", false)
end

function P.DarkMode()
    command("silent !kitty +kitten themes --reload-in=all Tokyo Night Storm")
    vim.o.background = "dark"
    vimscript("colorscheme tokyonight", false)
end

function P.ToggleThemeMode()
    if vim.o.background == "dark" then
        P.LightMode()
    else
        P.DarkMode()
    end
end

-- Sessions
add_command("Session", ":mksession! ~/.local/share/nvim/session.vim<CR>", {})
add_command("SessionRestore", ":source  ~/.local/share/nvim/session.vim<CR>", {})

add_command("LightMode", P.LightMode, {})
add_command("DarkMode", P.DarkMode, {})

return P
