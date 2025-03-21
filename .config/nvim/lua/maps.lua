local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("", "+", "$", opts)
keymap("", "-", "$", opts)
keymap("", '""', '"+y', opts)
keymap("", "<LeftMouse>", "<Nop>", opts)
keymap("i", "<LeftMouse>", "<Nop>", opts)
keymap("n", "<Esc>", "<CMD>nohl<CR>", opts)
keymap("i", "kj", "<Esc>", opts)
keymap("i", "kj", "<Esc>", opts)

-- Movement
keymap("", ",", ";", opts)
keymap("", ";", ",", opts)


-- Buffers and tabs
keymap("n", "<C-i>", "<C-i>", opts)
vim.keymap.set("n", "<Tab>", Snacks.picker.buffers)

keymap("n", "<S-Tab>", "<CMD>tabnext<CR>", opts)

keymap("", "ZA", "<CMD>wqa!<CR>", opts)

--  Move to window
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

--  Resize window
keymap("n", "<C-Left>", "<CMD>vertical resize-5<CR>", opts)
keymap("n", "<C-Down>", "<CMD>resize-5<CR>", opts)
keymap("n", "<C-Up>", "<CMD>resize+5<CR>", opts)
keymap("n", "<C-Right>", "<CMD>vertical resize+5<CR>", opts)

keymap("n", "<C-S-h>", "<CMD>vertical resize-5<CR>", opts)
keymap("n", "<C-S-j>", "<CMD>resize-5<CR>", opts)
keymap("n", "<C-S-k>", "<CMD>resize+5<CR>", opts)
keymap("n", "<C-S-l>", "<CMD>vertical resize+5<CR>", opts)

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

keymap("t", "<C-S-h>", "<C-\\><C-n><CMD>vertical resize-5<CR>i", opts)
keymap("t", "<C-S-j>", "<C-\\><C-n><CMD>resize-5<CR>i", opts)
keymap("t", "<C-S-k>", "<C-\\><C-n><CMD>resize+5<CR>i", opts)
keymap("t", "<C-S-l>", "<C-\\><C-n><CMD>vertical resize+5<CR>i", opts)
keymap("t", "<C-S-r>", "<C-\\><C-n><C-W>=i", opts)


keymap("t", "<A-h>", "<C-\\><C-n><CMD>vertical resize-5<CR>i", opts)
keymap("t", "<A-j>", "<C-\\><C-n><CMD>resize-5<CR>i", opts)
keymap("t", "<A-k>", "<C-\\><C-n><CMD>resize+5<CR>i", opts)
keymap("t", "<A-l>", "<C-\\><C-n><CMD>vertical resize+5<CR>i", opts)
keymap("t", "<A-r>", "<C-\\><C-n><C-W>=i", opts)
