local plugins = {
  "karb94/neoscroll.nvim",
  event = { "BufRead", "BufNewFile" },
  config = function()
    require("neoscroll").setup {
      mappings = { -- Keys to be mapped to their corresponding default scrolling animation
        "<C-b>",
        "<C-f>",
        "zt",
        "zz",
        "zb",
      },
    }
  end,
}

return plugins
