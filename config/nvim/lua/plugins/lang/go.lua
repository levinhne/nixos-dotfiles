local plugins = {
  {
    "fatih/vim-go",
    ft = "go",
    config = function()
      vim.g.go_doc_keywordprg_enabled = 0
    end,
  },
}

return plugins
