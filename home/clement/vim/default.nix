{
  pkgs,
  ecsls,
  ...
}: {
  imports = [./vim.nix];
  home.file = {
    ".config/nvim/lua".source = ./lua;
    ".config/nvim/ftplugin".source = ./ftplugin;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig =
      builtins.readFile ./.vimrc
      + ''
        lua require('dark-switch')
        lua require('settings')
        lua require('lazy').setup('plugins')
      '';

    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
      nvim-treesitter.withAllGrammars
    ];

    extraPackages = with pkgs; [tree-sitter];
  };
}
