-- dracula
-- return {
--   "Mofiqul/dracula.nvim",
--   priority = 1000,
--   config = function()
--     vim.cmd([[colorscheme dracula]])
--   end,
-- }

-- catppuccin
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "macchiato", -- Change this to "latte", "frappe", "macchiato", or "mocha"
      integrations = {
        treesitter = true,
        native_lsp = { enabled = true },
        lsp_trouble = true,
        cmp = true,
        gitsigns = true,
        telescope = true,
        nvimtree = true,
        which_key = true,
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
