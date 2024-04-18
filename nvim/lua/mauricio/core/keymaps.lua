vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("n", "<leader>L", ":Lazy<CR>", { desc = "Open Lazy panel" })
keymap.set("n", "<leader>t", "<cmd>ToggleTerm size=14<CR>", { desc = "Toggle terminal" })
keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Find file in tree" })
keymap.set("n", "<leader>cc", "<cmd>set colorcolumn=100<CR>", { desc = "Enable wrapline" })
keymap.set("n", "<leader>cx", "<cmd>set colorcolumn=0<CR>", { desc = "Disable wrapline" })
keymap.set("n", "<leader>q", "<cmd>bd<CR>", { desc = "Close buffer" })
keymap.set("n", "<leader>hh", "<cmd>noh<CR>", { desc = "Clear highlights" })
keymap.set("n", "<S-l>", "<S-$>", { desc = "Move to end of line" })
keymap.set("n", "<S-h>", "<S-^>", { desc = "Move to beginning of line" })
keymap.set("n", "<A-k>", "ddkkp", { desc = "Move line up" })
keymap.set("n", "<A-j>", "ddp", { desc = "Move line down" })
keymap.set("n", "<S-A-j>", "yyp", { desc = "Duplicate line" })
keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })

-- copilot
vim.keymap.set("i", "<C-Y>", 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})
vim.g.copilot_no_tab_map = true
