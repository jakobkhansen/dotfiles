require('gitsigns').setup {
    signs = {
        add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
        change       = {hl = 'GitSignsAdd',    text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        delete       = {hl = 'GitSignsDelete', text = '│', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        topdelete    = {hl = 'GitSignsDelete', text = '│', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        changedelete = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    },
  numhl = false,
  linehl = false,

  watch_index = {
    interval = 1000,
    follow_files = true
  },

  current_line_blame = false,
  current_line_blame_delay = 1000,
  current_line_blame_position = 'eol',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  word_diff = false,
}
