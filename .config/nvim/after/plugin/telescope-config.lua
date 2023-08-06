local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local utils = require("utils")

local P = {}

local open_xdg = function()
    return function(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        local cmd = "xdg-open"
        local path = entry[1]
        require("plenary.job")
            :new({
                command = cmd,
                args = { path },
            })
            :start()
        require("telescope.actions").close(prompt_bufnr)
    end
end

function P.find_dir(opts)
    pickers
        .new(opts, {
            prompt_title = "Find Directory",
            finder = finders.new_oneshot_job({ "fd", "--type", "d" }),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    if selection ~= nil then
                        local path = selection[1]
                        actions.close(prompt_bufnr)
                        vim.cmd("cd " .. path)
                    end
                end)
                return true
            end,
        })
        :find()
end

require("telescope").setup({
    defaults = {
        mappings = {
            n = {
                ["o"] = open_xdg(),
                ["p"] = require("telescope.actions.layout").toggle_preview,
            },
            i = {},
        },
        file_ignore_patterns = { "%.class", "change", "node_modules", "Caches" },
    },
    pickers = {
        git_commits = {
            mappings = {
                n = {
                    ["d"] = function()
                        local selection = action_state.get_selected_entry()
                        local hash = selection.value
                        vim.cmd("DiffviewOpen " .. hash .. "~1.." .. hash)
                    end,
                },
            },
        },
        lsp_references = {
            show_path = { "full" },
            fname_width = 60,
        },
        buffers = {
            mappings = {
                n = {
                    ["d"] = "delete_buffer",
                },
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
    },
})



function P.config_files(opts)
    local nvim_files = vim.split(vim.fn.glob("~/.config/nvim/lua/**/*lua"), "\n")
    local plugin_files = vim.split(vim.fn.glob("~/.config/nvim/after/**/*lua"), "\n")
    local config_files = {
        vim.env.HOME .. "/.config/nvim/init.lua",
        vim.env.HOME .. "/.config/i3/config",
        vim.env.HOME .. "/.config/sway/config",
        vim.env.HOME .. "/.config/i3status/config",
        vim.env.HOME .. "/.config/ranger/rc.conf",
        vim.env.HOME .. "/.config/zathura/zathurarc",
        vim.env.HOME .. "/.config/kitty/kitty.conf",
        vim.env.HOME .. "/.config/compton/compton.conf",
        vim.env.HOME .. "/.config/yabai/yabairc",
        vim.env.HOME .. "/.config/skhd/skhdrc",
        vim.env.HOME .. "/.zshrc",
        vim.env.HOME .. "/.bash_aliases",
    }

    for _, file in ipairs(nvim_files) do
        table.insert(config_files, file)
    end

    for _, file in ipairs(plugin_files) do
        table.insert(config_files, file)
    end

    pickers
        .new(opts, {
            prompt_title = "Configuration files",
            finder = finders.new_table({
                results = config_files,
            }),
            sorter = conf.generic_sorter(opts),
        })
        :find()
end

require("telescope").load_extension("fzf")
require("telescope").load_extension("neoclip")

return P
