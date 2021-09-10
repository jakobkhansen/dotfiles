require('nvim-autopairs').setup({
    pairs_map = {
      ["'"] = "'",
      ['"'] = '"',
      ['('] = ')',
      ['['] = ']',
      ['{'] = '}',
      ['`'] = '`',
      ['<'] = '>',
    },
    disable_filetype = { "TelescopePrompt" },
    break_line_filetype = nil, -- mean all file type
    html_break_line_filetype = {'html' , 'vue' , 'typescriptreact' , 'svelte' , 'javascriptreact'},
    --ignored_next_char = "%w",
})

require('nvim-autopairs.completion.cmp').setup({
    map_cr = true,
    map_complete = true,
})


require('nvim-treesitter.configs').setup {
    autopairs = {enable = true}
}