local command = vim.api.nvim_command
local vimscript = vim.api.nvim_exec
local tree_cb = require'nvim-tree.config'.nvim_tree_callback
local noremap = require('vimp').noremap

vim.g.nvim_tree_ignore = {'*.class'}
vim.g.nvim_tree_quit_on_open = 1
vim.g.nvim_tree_hide_dotfiles = 1
vim.g.nvim_tree_window_picker_exclude = {
    buftype = {
        'terminal',
        'term',
        'term://zsh'
    }
}

local bindings = {
  { key = {"l", "o", "<2-LeftMouse>"}, cb = tree_cb("edit") },
  { key = {"<2-RightMouse>", "<CR>"},    cb = tree_cb("cd") },
  { key = "<C-v>",                        cb = tree_cb("vsplit") },
  { key = "<C-x>",                        cb = tree_cb("split") },
  { key = "<C-t>",                        cb = tree_cb("tabnew") },
  { key = "<",                            cb = tree_cb("prev_sibling") },
  { key = ">",                            cb = tree_cb("next_sibling") },
  { key = "P",                            cb = tree_cb("parent_node") },
  { key = "h",                            cb = tree_cb("close_node") },
  { key = "<Tab>",                        cb = tree_cb("preview") },
  { key = "K",                            cb = tree_cb("first_sibling") },
  { key = "J",                            cb = tree_cb("last_sibling") },
  { key = "I",                            cb = tree_cb("toggle_ignored") },
  { key = "z",                            cb = tree_cb("toggle_dotfiles") },
  { key = "R",                            cb = tree_cb("refresh") },
  { key = "a",                            cb = tree_cb("create") },
  { key = "d",                            cb = tree_cb("remove") },
  { key = "r",                            cb = tree_cb("rename") },
  { key = "<C-r>",                        cb = tree_cb("full_rename") },
  { key = "x",                            cb = tree_cb("cut") },
  { key = "c",                            cb = tree_cb("copy") },
  { key = "p",                            cb = tree_cb("paste") },
  { key = "y",                            cb = tree_cb("copy_name") },
  { key = "Y",                            cb = tree_cb("copy_path") },
  { key = "gy",                           cb = tree_cb("copy_absolute_path") },
  { key = "[c",                           cb = tree_cb("prev_git_item") },
  { key = "]c",                           cb = tree_cb("next_git_item") },
  { key = "<BS>",                            cb = tree_cb("dir_up") },
  { key = "q",                            cb = tree_cb("close") },
  { key = "g?",                           cb = tree_cb("toggle_help") },
}


vim.g.nvim_tree_icons = {
    default = "",
    symlink = "",
    git = {
        unstaged = "✗",
        staged = "✓",
        unmerged = "",
        renamed = "➜",
        untracked = "★",
        deleted = "",
        ignored = "◌"
    },
    folder = {
        -- disable indent_markers option to get arrows working or if you want both arrows and indent then just add the arrow icons in front            ofthe default and opened folders below!
        -- arrow_open = "",
        -- arrow_closed = "",
        default = "",
        open = "",
        empty = "", -- 
        empty_open = "",
        symlink = "",
        symlink_open = ""
    }
}


function Set_cwd()
    dir = vim.fn.expand('%:p:h')
    cd_command = 'cd ' .. dir
    command('windo ' .. cd_command)
end


vimscript('autocmd FileType NvimTree map <buffer> <Leader>bc <CMD>lua Set_cwd()<CR>', false)

require'nvim-tree'.setup {
    auto_close = true,
    update_cwd = true,

    system_open = {
        -- the command to run this, leaving nil should work in most cases
        cmd  = 'xdg-open',
        -- the command arguments as a list
        args = {}
    },

    view = {

        mappings = {
          -- custom only false will merge the list with the default mappings
          -- if true, it will only use your list to set the mappings
          custom_only = false,
          -- list of mappings to set on the tree manually
          list = bindings
        }
    }
}

require('fm-nvim').setup{
	config =
	{
		edit_cmd = "edit", -- opts: 'tabedit'; 'split'; 'pedit'; etc...
		border   = "rounded", -- opts: 'rounded'; 'double'; 'single'; 'solid'; 'shawdow'
		height   = 0.9,
		width    = 0.9,
	}
}
