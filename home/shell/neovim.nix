{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

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

    stylua
    prettier
    black
    isort
    sql-formatter
  ];
}
