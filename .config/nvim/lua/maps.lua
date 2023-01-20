local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("", "+", "$", opts)
keymap("", '""', '"+y', opts)
keymap("", "<LeftMouse>", "<Nop>", opts)
keymap("i", "<LeftMouse>", "<Nop>", opts)
keymap("n", "<Esc>", "<CMD>nohl<CR>", opts)

-- Movement
keymap("", ",", ";", opts)
keymap("", ";", ",", opts)

-- Text manipulation
keymap("", "<A-k>", "<CMD>m-2<CR>", opts)
keymap("", "<A-j>", "<CMD>m+<CR>", opts)

-- Buffers and tabs
keymap("n", "<Tab>", "<CMD>bn<CR>", opts)
keymap("n", "<S-Tab>", "<CMD>bp<CR>", opts)

keymap("n", "<A-l>", "<CMD>tabnext<CR>", opts)
keymap("n", "<A-h>", "<CMD>tabprevious<CR>", opts)

keymap("", "ZA", "<CMD>wqa!<CR>", opts)

--  Move to window
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

--  Resize window
keymap("n", "<C-m-h>", "<CMD>vertical resize-5<CR>", opts)
keymap("n", "<C-m-j>", "<CMD>resize-5<CR>", opts)
keymap("n", "<C-m-k>", "<CMD>resize+5<CR>", opts)
keymap("n", "<C-m-l>", "<CMD>vertical resize+5<CR>", opts)
keymap("n", "<C-m-r>", "<C-W>=", opts)

--  Move horizontally
keymap("", "zh", "10zh", opts)
keymap("", "zl", "10zl", opts)

--  Delete all buffers to left and right
keymap("", "<F1>", "<CMD>lua MiniBufremove.wipeout(0, true)<CR>", opts)
keymap("", "<F2>", "<CMD>bufdo bd<CR>", opts)

-- Terminal
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", opts)

keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", opts)
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", opts)
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", opts)
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", opts)
keymap("t", "<A-l>", "<C-\\><C-n><CMD>tabnext<CR>", opts)
keymap("t", "<A-h>", "<C-\\><C-n><CMD>tabnext<CR>", opts)

keymap("t", "<C-M-h>", "<C-\\><C-n><CMD>vertical resize-5<CR>i", opts)
keymap("t", "<C-M-j>", "<C-\\><C-n><CMD>resize-5<CR>i", opts)
keymap("t", "<C-M-k>", "<C-\\><C-n><CMD>resize+5<CR>i", opts)
keymap("t", "<C-M-l>", "<C-\\><C-n><CMD>vertical resize+5<CR>i", opts)
keymap("t", "<C-M-r>", "<C-\\><C-n><C-W>=i", opts)
