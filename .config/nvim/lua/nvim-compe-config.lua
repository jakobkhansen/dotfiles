require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    spell = true;
    tags = true;
    snippets_nvim = true;
    treesitter = true;
  };
}


--local remap = vim.api.nvim_set_keymap
--local npairs = require('nvim-autopairs')

---- skip it, if you use another global object
--_G.MUtils= {}

--vim.g.completion_confirm_key = ""
--MUtils.completion_confirm=function()
  --if vim.fn.pumvisible() ~= 0  then
    --if vim.fn.complete_info()["selected"] ~= -1 then
      --vim.fn["compe#confirm"]()
      --return npairs.esc("<c-y>")
    --else
      --vim.defer_fn(function()
        --vim.fn["compe#confirm"]("<cr>")
      --end, 20)
      --return npairs.esc("<c-n>")
    --end
  --else
    --return npairs.check_break_line_char()
  --end
--end


--remap('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})
