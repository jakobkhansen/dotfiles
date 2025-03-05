local add_command = vim.api.nvim_create_user_command
local vimscript = vim.api.nvim_exec
local command = vim.api.nvim_command
local keymap = vim.api.nvim_set_keymap
local keymap_opts = { noremap = true, silent = true }
local P = {}

-- Theme
function P.LightMode()
    command("silent !kitty +kitten themes --reload-in=all Tokyo Night Day")
    vim.o.background = "light"
    vimscript("colorscheme tokyonight", false)
end

function P.DarkMode()
    command("silent !kitty +kitten themes --reload-in=all Tokyo Night Moon")
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

function P.ToggleTabLine()
    if vim.o.showtabline == 2 then
        vim.o.showtabline = 0
    else
        vim.o.showtabline = 2
    end
end

add_command("ToggleTabLine", P.ToggleTabLine, {})

-- Sessions
add_command("Session", ":mksession! ~/.local/share/nvim/session.vim<CR>", {})
add_command("SessionRestore", ":source  ~/.local/share/nvim/session.vim<CR>", {})

add_command("LightMode", P.LightMode, {})
add_command("DarkMode", P.DarkMode, {})

return P
