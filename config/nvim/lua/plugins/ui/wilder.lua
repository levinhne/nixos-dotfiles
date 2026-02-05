local plugins = {
  {
    "gelguy/wilder.nvim",
    config = function()
      local wilder = require "wilder"
      wilder.setup {
        modes = { ":", "/", "?" },
        next_key = "<Tab>",
        previous_key = "<S-Tab>",
        accept_key = "<Down>",
        reject_key = "<Up>",
      }
      wilder.set_option("pipeline", {
        wilder.branch(wilder.cmdline_pipeline(), wilder.search_pipeline()),
      })
      wilder.set_option(
        "renderer",
        -- wilder.popupmenu_renderer {
        --   highlighter = wilder.basic_highlighter(),
        --   left = { " ", wilder.popupmenu_devicons() },
        --   right = { " ", wilder.popupmenu_scrollbar() },
        -- },
        wilder.popupmenu_renderer(
          -- wilder.popupmenu_palette_theme {
          --   -- 'single', 'double', 'rounded' or 'solid'
          --   -- can also be a list of 8 characters, see :h wilder#popupmenu_palette_theme() for more details
          --   border = "rounded",
          --   max_height = "75%", -- max height of the palette
          --   min_height = 0, -- set to the same as 'max_height' for a fixed height window
          --   prompt_position = "top", -- 'top' or 'bottom' to set the location of the prompt
          --   reverse = 0, -- set to 1 to reverse the order of the list, use in combination with 'prompt_position'
          --   left = { " ", wilder.popupmenu_devicons() },
          --   right = { " ", wilder.popupmenu_scrollbar() },
          -- }
          wilder.popupmenu_border_theme {
            highlights = {
              border = "", -- highlight to use for the border
            },
            -- 'single', 'double', 'rounded' or 'solid'
            -- can also be a list of 8 characters, see :h wilder#popupmenu_border_theme() for more details
            border = "rounded",
            min_width = "100%",
            max_height = "25%",
            reverse = 0,
            left = { " ", wilder.popupmenu_devicons() },
            right = { " ", wilder.popupmenu_scrollbar() },
          }
        )
      )
    end,
    event = "User FilePost",
  },
}

return plugins
