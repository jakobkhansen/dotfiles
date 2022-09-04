local command = vim.api.nvim_command
local vimscript = vim.api.nvim_exec
local add_command = vim.api.nvim_create_user_command

local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

local P = {}

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

function P.getFirstDayOfCurrentMonth()
    return os.date("%Y") .. "-" .. os.date("%m") .. "-01"
end

function P.isFileOrDir(path)
    local p = io.popen(("file %q"):format(path))
    if p then
        local out = p:read():gsub("^[^:]-:%s*(%w+).*", "%1")
        p:close()
        return out
    end
end

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

function P.showFloatingPrompt(display_text, on_submit, on_close)
    local prompt = Input({
        position = "50%",
        size = {
            width = 60,
            height = 2,
        },
        relative = "editor",
        border = {
            style = "rounded",
            text = {
                top = display_text,
                top_align = "center",
            },
        },
        win_options = {
            winhighlight = "Normal:Normal",
        },
    }, {
        prompt = "> ",
        on_submit = on_submit,
        on_close = on_close,
    })

    prompt:mount()

    -- close the input window by pressing `<Esc>` on normal mode
    prompt:map("n", "<Esc>", prompt.input_props.on_close, { noremap = true })

    prompt:on(event.BufLeave, function()
        prompt:unmount()
    end)
end

add_command("Session", ":mksession! ~/.local/share/nvim/session.vim<CR>", {})
add_command("SessionRestore", ":source  ~/.local/share/nvim/session.vim<CR>", {})

add_command("LightMode", P.LightMode, {})
add_command("DarkMode", P.DarkMode, {})

return P
