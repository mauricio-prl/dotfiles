vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap

-- insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- normal mode
keymap.set("n", "<A-j>", "ddp", { desc = "Move line down" })
keymap.set("n", "<A-k>", "ddkkp", { desc = "Move line up" })
keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })
keymap.set("n", "<S-A-j>", "yyp", { desc = "Duplicate line" })
keymap.set("n", "<S-h>", "<S-^>", { desc = "Move to beginning of line" })
keymap.set("n", "<S-l>", "<S-$>", { desc = "Move to end of line" })
keymap.set("n", "<leader>L", "<cmd>Lazy<CR>", { desc = "Open Lazy panel" })
keymap.set("n", "<leader>cc", "<cmd>set colorcolumn=100<CR>", { desc = "Enable wrapline" })
keymap.set("n", "<leader>cx", "<cmd>set colorcolumn=0<CR>", { desc = "Disable wrapline" })
keymap.set("n", "<leader>hh", "<cmd>noh<CR>", { desc = "Clear highlights" })
keymap.set("n", "<leader>q", "<cmd>bd<CR>", { desc = "Close buffer" })

-- visual mode
keymap.set("v", "<S-h>", "<S-^>", { desc = "Select to beginning of line" })
keymap.set("v", "<S-l>", "<S-$>", { desc = "Select to end of line" })

-- copilot
vim.keymap.set("i", "<C-Y>", 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})
