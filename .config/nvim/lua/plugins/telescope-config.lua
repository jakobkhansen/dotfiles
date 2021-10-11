local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require('telescope.actions')
local action_state = require "telescope.actions.state"
local command = vim.api.nvim_command

require('telescope').setup{
    defaults = {
        file_ignore_patterns = {"%.class", "%.pdf"}
    },
}


function _G.telescope_find_dir(opts)
    pickers.new(opts, {
        prompt_title = 'Find Directory',
        finder = finders.new_oneshot_job(
            {'fd'},
            {'-t','d', '-a'}
        ),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              command('cd ' .. selection[1])
              return
          end)
          return true
        end,
    }):find()
end

function _G.telescope_find_dir_home(opts)
    pickers.new(opts, {
        prompt_title = 'Find Directory',
        finder = finders.new_oneshot_job(
            {'fd', '.', vim.fn.expand('$HOME')},
            {'-t','d', '-a'}
        ),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              command('cd ' .. selection[1])
              return
          end)
          return true
        end,
    }):find()
end
