local map = vimp.map
local vimscript = vim.api.nvim_exec


require("toggleterm").setup{
  -- size can be a number or function which is passed the current terminal
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<C-\>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  persist_size = true,
  direction = 'horizontal',
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = 'single',
    --width = <value>,
    --height = <value>,
    winblend = 3,
    highlights = {
      border = "Normal",
      background = "Normal",
    }
  }
}

map({'silent'}, '<Leader>tf', '<CMD>terminal<CR>')
map({'silent'}, '<Leader>tt', '<Cmd>exe v:count1 . "ToggleTerm"<CR>')

vimscript('au TermOpen * map <buffer> <Leader>bc ipwd\\|xclip -selection clipboard<CR><C-\\><C-n>:cd <C-r>+<CR>i', false)

vimscript('au FileType toggleterm map <buffer> <Tab> <Nop>', false)

vimscript('au TermOpen * startinsert', false)

vimscript('au TermOpen * map <buffer> <Leader>bd <CMD>bd!<CR>', false)
