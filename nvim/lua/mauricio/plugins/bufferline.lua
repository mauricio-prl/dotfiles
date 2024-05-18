return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  version = "*",
  keys = {
    { "<leader>bp", "<cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
    { "<leader>br", "<cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    { "<A-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<A-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
  },
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    options = {
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        local s = " "
        for e, n in pairs(diagnostics_dict) do
          local sym = e == "error" and " " or (e == "warning" and " " or "")
          s = s .. n .. sym
        end
        return s
      end,
      always_show_bufferline = false,
      offsets = {
        {
          filetype = "nvim-tree",
          text = "Nvim-tree",
          highlight = "Directory",
          text_align = "left",
        },
      },
    },
  },
}
