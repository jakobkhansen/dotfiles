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
                top_align = "center"
            }
        },
        win_options = {
            winhighlight = "Normal:Normal"
        },
    }, {
        prompt = "> ",
        on_submit = on_submit,
        on_close = on_close,
    })

    prompt:mount()

    -- close the input window by pressing `<Esc>` on normal mode
    prompt:map("n", "<Esc>", prompt.input_props.on_close, { noremap = true })

    prompt:on(event.BufLeave, function ()
        prompt:unmount()
    end)
end

function P.treesitterExecQuery(bufnr, query)
    local filetype = vim.bo.ft
        local ts = vim.treesitter
    local parsed_query = ts.parse_query(filetype, query)
    local parser = ts.get_parser(bufnr, filetype)
    local root = parser:parse()[1]:root()
    local start_row, _, end_row, _ = root:range()

    local headings = {}
    for _, node in parsed_query:iter_captures(root, bufnr, start_row, end_row) do
        local row, _ = node:range()
        local line = vim.fn.getline(row + 1)
        print(row)

    end
    return headings

end

function P.onEveryLine(callback)
    local num_lines = vim.api.nvim_buf_line_count(0)
    command("0")
    for i=0,num_lines do
        callback(i)
    end
end


add_command("LightMode", P.LightMode, {})
add_command("DarkMode", P.DarkMode, {})

return P
