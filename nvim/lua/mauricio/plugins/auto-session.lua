return {
  "rmagatti/auto-session",
  config = function()
    local auto_session = require("auto-session")
    local keymap = vim.keymap

    auto_session.setup({
      auto_restore_enabled = true,
      auto_session_suppress_dirs = { "~/", "~/Downloads", "~/Documents", "~Desktop" },
    })

    keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
    keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" })
  end,
}
