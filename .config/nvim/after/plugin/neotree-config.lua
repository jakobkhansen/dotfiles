vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

require("neo-tree").setup({
    close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
    popup_border_style = "rounded",
    enable_git_status = false,
    enable_diagnostics = false,
    sort_case_insensitive = false, -- used when sorting files and directories in the tree

    window = {
        mappings = {
            ["<space>"] = "none",
            ["l"] = "open_with_window_picker",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            -- ["S"] = "split_with_window_picker",
            -- ["s"] = "vsplit_with_window_picker",
            ["t"] = "open_tabnew",
            ["w"] = "open_with_window_picker",
            ["h"] = "close_node",
            ["z"] = "close_all_nodes",
            --["Z"] = "expand_all_nodes",
            ["a"] = {
                "add",
                -- some commands may take optional config options, see `:h neo-tree-mappings` for details
                config = {
                    show_path = "none", -- "none", "relative", "absolute"
                },
            },
            ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add".
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
            -- ["c"] = {
            --  "copy",
            --  config = {
            --    show_path = "none" -- "none", "relative", "absolute"
            --  }
            --}
            ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
        },
    },
    nesting_rules = {},
    filesystem = {
        window = {
            mappings = {
                ["<bs>"] = "navigate_up",
                ["<cr>"] = "set_root",
                ["H"] = "toggle_hidden",
                ["/"] = "",
                ["D"] = "fuzzy_finder_directory",
                ["f"] = "filter_on_submit",
                ["<c-x>"] = "clear_filter",
                ["[g"] = "prev_git_modified",
                ["]g"] = "next_git_modified",
                ["o"] = "system_open",
            },
        },
        commands = {
            system_open = function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                vim.api.nvim_command("silent !xdg-open " .. path .. " &; disown")
            end,
        },
    },
})
