local ls = require'luasnip'
local vimp = require('vimp')
local snoremap = vimp.snoremap
local imap = vimp.imap
local inoremap = vimp.inoremap


-- Every unspecified option will be set to the default.
ls.config.set_config({
	history = true,
	-- Update more often, :h events for more info.
	updateevents = 'TextChanged,TextChangedI'
})


ls.snippets = {


    markdown = {
        ls.parser.parse_snippet({trig="math"}, "\\$$0\\$"),
        ls.parser.parse_snippet({trig="checkempty"}, "[ ]"),
        ls.parser.parse_snippet({trig="checkfull"}, "[x]"),
    },
    norg = {
        ls.parser.parse_snippet({trig="code"}, "@code ${1:java}\n$0\n@end"),
    }
}


snoremap({'silent'}, '<C-k>', '<CMD>lua require("luasnip").jump(1)<CR>')
snoremap({'silent'}, '<C-j>', '<CMD>lua require("luasnip").jump(-1)<CR>')
imap({'silent'}, '<C-j>', '<CMD>lua require("luasnip").jump(-1)<CR>')
imap({'silent'}, '<C-k>', '<CMD>lua require("luasnip").jump(1)<CR>')

--snoremap <silent> <C-k> <cmd>lua require'luasnip'.jump(1)<Cr>
--snoremap <silent> <C-j> <cmd>lua require'luasnip'.jump(-1)<Cr>

--imap <silent> <C-k> <CMD>lua require'luasnip'.jump(1)<CR>
--inoremap <silent> <C-j> <cmd>lua require'luasnip'.jump(-1)<Cr>
require("luasnip/loaders/from_vscode").lazy_load()
