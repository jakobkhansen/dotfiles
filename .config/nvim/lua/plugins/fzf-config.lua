local M = {}

require'fzf-lua'.setup {
    preview = {
      -- default     = 'bat',           -- override the default previewer?
                                        -- default uses the 'builtin' previewer
      border         = 'border',        -- border|noborder, applies only to
                                        -- native fzf previewers (bat/cat/git/etc)
      wrap           = 'nowrap',        -- wrap|nowrap
      hidden         = 'nohidden',      -- hidden|nohidden
      vertical       = 'down:45%',      -- up|down:size
      horizontal     = 'right:50%',     -- right|left:size
      layout         = 'flex',          -- horizontal|vertical|flex
      flip_columns   = 120,             -- #cols to switch to horizontal on flex
      -- Only used with the builtin previewer:
      title          = true,            -- preview border title (file/buf)?
      scrollbar      = 'float',         -- `false` or string:'float|border'
                                        -- float:  in-window floating border
                                        -- border: in-border chars (see below)
      scrolloff      = '-2',            -- float scrollbar offset from right
                                        -- applies only when scrollbar = 'float'
      scrollchars    = {'█', '' },      -- scrollbar chars ({ <full>, <empty> }
                                        -- applies only when scrollbar = 'border'
      delay          = 100,             -- delay(ms) displaying the preview
                                        -- prevents lag on fast scrolling
      winopts = {                       -- builtin previewer window options
        number            = true,
        relativenumber    = false,
        cursorline        = true,
        cursorlineopt     = 'both',
        cursorcolumn      = false,
        signcolumn        = 'no',
        list              = false,
        foldenable        = false,
        foldmethod        = 'manual',
      },
    },
    fzf_opts = {
      -- options are sent as `<left>=<right>`
      -- set to `false` to remove a flag
      -- set to '' for a non-value flag
      -- for raw args use `fzf_args` instead
      ['--layout'] = 'default'
    },
}

M.fzf_dirs = function(opts)
  local fzf_lua = require'fzf-lua'
  opts = opts or {}
  opts.prompt = "Directories> "
  opts.fn_transform = function(x)
    return fzf_lua.utils.ansi_codes.magenta(x)
  end
  opts.actions = {
    ['default'] = function(selected)
      vim.cmd("cd " .. selected[1])
    end
  }
  fzf_lua.fzf_exec("fd --type d --hidden", opts)
end

return M
