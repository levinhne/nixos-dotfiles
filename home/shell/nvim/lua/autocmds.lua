require "nvchad.autocmds"


local autocmd = vim.api.nvim_create_autocmd

local languages = { "go", "html", "css", "Makefile" }
for _, language in ipairs(languages) do
  autocmd("FileType", {
    pattern = language,
    callback = function()
      vim.bo.tabstop = 4
      vim.bo.softtabstop = 4
      vim.bo.shiftwidth = 4
      vim.bo.expandtab = true
    end,
  })
end

