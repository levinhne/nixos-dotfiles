local plugins = {
  {
    "greggh/claude-code.nvim",
    cmd = {
      "ClaudeCode",
      "ClaudeCodeContinue",
      "ClaudeCodeResume",
      "ClaudeCodeVerbose",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "claude code" },
      { "<leader>aC", "<cmd>ClaudeCodeContinue<cr>", desc = "claude continue" },
      { "<leader>ar", "<cmd>ClaudeCodeResume<cr>", desc = "claude resume" },
      { "<leader>av", "<cmd>ClaudeCodeVerbose<cr>", desc = "claude verbose" },
      { "<C-,>", "<cmd>ClaudeCode<cr>", mode = "n", desc = "toggle claude" },
    },
    opts = {
      window = {
        position = "float",
        float = {
          width = "80%",
          height = "80%",
          row = "center",
          col = "center",
          relative = "editor",
          border = "rounded",
        },
      },
      keymaps = {
        toggle = {
          normal = false,
          terminal = "<C-,>",
          variants = {
            continue = false,
            verbose = false,
          },
        },
      },
    },
  },
}

return plugins
