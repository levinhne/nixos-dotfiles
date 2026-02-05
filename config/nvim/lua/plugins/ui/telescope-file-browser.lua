local plugins = {
  "nvim-telescope/telescope-file-browser.nvim",
  event = { "BufRead", "BufNewFile" },
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("telescope").load_extension("file_browser")
    require("telescope").setup {
      defaults = {
        file_ignore_patterns = { ".git/", "node_modules/", "venv", },
      },
    }
  end,
  lazy = false,
}

return plugins
