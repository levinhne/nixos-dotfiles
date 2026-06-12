{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
    initLua = ''
      vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
      vim.g.mapleader = " "

      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not vim.uv.fs_stat(lazypath) then
        local repo = "https://github.com/folke/lazy.nvim.git"
        vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
      end

      vim.opt.rtp:prepend(lazypath)

      local lazy_config = require("configs.lazy")

      require("lazy").setup({
        {
          "NvChad/NvChad",
          lazy = false,
          branch = "v2.5",
          import = "nvchad.plugins",
        },
        { import = "plugins" },
      }, lazy_config)

      dofile(vim.g.base46_cache .. "defaults")
      dofile(vim.g.base46_cache .. "statusline")

      require("options")
      require("autocmds")

      vim.schedule(function()
        require("mappings")
      end)
    '';
  };

  xdg.configFile."nvim/lua".source = ./nvim/lua;

  home.packages = with pkgs; [
    ripgrep
    fd
    fzf
    lazygit
    zoxide
    python3
    go
    gotools

    lua-language-server
    gopls
    golangci-lint-langserver
    pyright
    typescript
    typescript-language-server
    tailwindcss-language-server
    vscode-langservers-extracted
    nil

    stylua
    prettier
    black
    isort
    sql-formatter
  ];
}
