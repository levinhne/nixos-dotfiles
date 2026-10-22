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


-- Neovim >= 0.11 default TermOpen sets signcolumn=no, which removes NvTerm's left padding
-- (NvChad/ui#7a8e9db). Runs after the default nvim.terminal autocmd, so it wins.
autocmd("TermOpen", {
  callback = function()
    vim.wo[0][0].signcolumn = "yes"
  end,
})
