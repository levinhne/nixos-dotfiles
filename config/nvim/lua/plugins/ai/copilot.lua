local plugins = {
  {
    "github/copilot.vim",
    event = "BufEnter",
    config = function()
      vim.g.copilot_filetypes = {
        html = false,
      }
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_enabled = true
    end,
  },
}

return plugins
