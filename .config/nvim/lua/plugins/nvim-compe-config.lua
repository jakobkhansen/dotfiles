local remap = vim.api.nvim_set_keymap
local npairs = require('nvim-autopairs')
_G.CompeConfig = {}

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
    luasnip = true;
    treesitter = true;
    neorg = true;
  };
}

vim.api.nvim_command([[
    autocmd BufEnter *.md :setlocal spell
    autocmd BufEnter *.norg :setlocal spell
]])

vim.g.completion_confirm_key = ""
function CompeConfig.compe_completion_confirm ()
  if vim.fn.pumvisible() ~= 0  then
    if vim.fn.complete_info()["selected"] ~= -1 then
      return vim.fn["compe#confirm"](npairs.esc("<c-r>"))
    else
      vim.defer_fn(function()
        vim.fn["compe#confirm"]("<cr>")
      end, 20)
      return npairs.autopairs_cr()
    end
  else
    return npairs.autopairs_cr()
  end
end

remap('i' , '<CR>','v:lua.CompeConfig.compe_completion_confirm()', { expr = true, noremap = true })
remap('i', '<Tab>', 'pumvisible() ? "<C-n>" : "<Tab>"', { expr = true })
remap('i', '<S-Tab>', 'pumvisible() ? "<C-p>" : "<S-Tab>"', { expr = true })
