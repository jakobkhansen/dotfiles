local keymap = vim.api.nvim_set_keymap
local vimscript = vim.api.nvim_exec


local opts = { noremap = true, silent = true }
local term_opts = { silent = true }


keymap("", "+", "$", opts)
keymap("", '""', '"+y', opts)
keymap("", "<LeftMouse>", "<Nop>", opts)
keymap("i", "<LeftMouse>", "<Nop>", opts)

-- Movement
keymap("", "J", "10j", opts)
keymap("", "K", "10k", opts)

keymap("", ";", ",", opts)
keymap("", ",", ";", opts)


-- Text manipulation
keymap("", "<A-k>", "<CMD>m-2<CR>", opts)
keymap("", "<A-j>", "<CMD>m+<CR>", opts)
keymap("i", "<C-v>", "<C-r>0", opts)

-- Buffers and tabs
keymap("n", "<Tab>", "<CMD>bn<CR>", opts)
keymap("n", "<S-Tab>", "<CMD>bp<CR>", opts)

keymap("n", "<A-Tab>", "<CMD>tabNext<CR>", opts)
keymap("n", "<A-S-Tab>", "<CMD>tabprevious<CR>", opts)

--  Move to buffer
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)


--  Resize buffers
keymap("n", "<C-m-h>", "<CMD>vertical resize-5<CR>", opts)
keymap("n", "<C-m-j>", "<CMD>resize-5<CR>", opts)
keymap("n", "<C-m-k>", "<CMD>resize+5<CR>", opts)
keymap("n", "<C-m-l>", "<CMD>vertical resize+5<CR>", opts)
keymap("n", "<C-A-r>", "<C-W>=", opts)

--  Move horizontally
keymap("", "zh", "10zh", opts)
keymap("", "zl", "10zl", opts)

--  Delete all buffers to left and right
keymap("", "<F3>", "<CMD>%bdelete|edit #<CR>", opts)

-- Terminal
keymap("t", "<C-q>", "<Esc>", opts)
keymap("t", "<Esc>", "<C-\\><C-n>", opts)

keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", opts)
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", opts)
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", opts)
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", opts)

keymap("t", "<C-M-h>", "<C-\\><C-n><CMD>vertical resize-5<CR>i", opts)
keymap("t", "<C-M-h>", "<C-\\><C-n><CMD>resize-5<CR>i", opts)
keymap("t", "<C-M-h>", "<C-\\><C-n><CMD>resize+5<CR>i", opts)
keymap("t", "<C-M-h>", "<C-\\><C-n><CMD>vertical resize+5<CR>i", opts)
keymap("t", "<C-M-r>", "<C-\\><C-n><C-W>=i", opts)



-- Master
function _G.RangeCodeActions()
    local startPos = vim.fn.getcharpos("'<")
    local endPos = vim.fn.getcharpos("'>")
    print(vim.inspect(startPos))
    print(vim.inspect(endPos))
end

keymap("n", "<C-q>", '', {callback = vim.lsp.buf.code_action})
keymap("v", "<C-q>", "<Esc>gv<CMD>lua vim.lsp.buf.range_code_action()<CR>", opts)
