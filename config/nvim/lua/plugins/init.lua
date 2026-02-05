local cmp = require "cmp"

return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },

  -- cmp
  {
    "hrsh7th/nvim-cmp",
    opts = {
      mapping = {
        ["<Down>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif require("luasnip").expand_or_jumpable() then
            require("luasnip").expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<Up>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      },
    },
  },

  -- ui
  { import = "plugins.ui.wilder" },
  { import = "plugins.ui.neoscroll" },
  { import = "plugins.ui.telescope-file-browser" },

  -- lang
  { import = "plugins.lang.go" },

  -- ai 
  { import = "plugins.ai.copilot"},

  -- git 
  { import = "plugins.git.lazygit" },

  -- tools 
  { import = "plugins.tools.fzf" }, 
  { import = "plugins.tools.zoxide" }
}
