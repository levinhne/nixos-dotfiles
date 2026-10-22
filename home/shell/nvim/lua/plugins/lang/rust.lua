-- rust-analyzer, rustfmt, clippy, lldb-dap come from Nix (home/shell/neovim.nix), not mason
local plugins = {
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false, -- already lazy by filetype
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, bufnr)
            local map = function(lhs, rhs, desc)
              vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
            end
            map("<leader>ca", function() vim.cmd.RustLsp "codeAction" end, "rust code action")
            map("<leader>rr", function() vim.cmd.RustLsp "runnables" end, "rust runnables")
            map("<leader>rt", function() vim.cmd.RustLsp "testables" end, "rust testables")
            map("<leader>rd", function() vim.cmd.RustLsp "debuggables" end, "rust debuggables")
            map("<leader>re", function() vim.cmd.RustLsp "expandMacro" end, "rust expand macro")
            map("<leader>rc", function() vim.cmd.RustLsp "openCargo" end, "rust open Cargo.toml")
            map("K", function() vim.cmd.RustLsp { "hover", "actions" } end, "rust hover actions")
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              check = { command = "clippy" },
            },
          },
        },
      }
    end,
  },

  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = { cmp = { enabled = true } },
    },
    config = function(_, opts)
      require("crates").setup(opts)
      require("cmp").setup.buffer { sources = { { name = "crates" } } }
    end,
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "dap toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "dap continue" },
      { "<leader>do", function() require("dap").step_over() end, desc = "dap step over" },
      { "<leader>di", function() require("dap").step_into() end, desc = "dap step into" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "dap step out" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "dap repl" },
      { "<leader>dq", function() require("dap").terminate() end, desc = "dap terminate" },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "rust", "toml" })
    end,
  },
}

return plugins
