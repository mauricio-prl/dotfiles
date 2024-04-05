vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("n", "<leader>L", ":Lazy<CR>", { desc = "Open Lazy panel" })
keymap.set("n", "<leader>t", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
keymap.set("n", "<leader>cc", "<cmd>set colorcolumn=100<CR>", { desc = "Enable wrapline" })
keymap.set("n", "<leader>cx", "<cmd>set colorcolumn=0<CR>", { desc = "Disable wrapline" })

-- copilot
vim.keymap.set("i", "<C-Y>", 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})
vim.g.copilot_no_tab_map = true
