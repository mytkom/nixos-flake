{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    withPython3 = true; # molten-nvim is a python remote plugin
    withRuby = false;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      molten-nvim
      image-nvim # for image rendering (needs a kitty-graphics terminal)
      (nvim-treesitter.withAllGrammars)
      nvim-cmp
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      luasnip
      harpoon
      plenary-nvim
      undotree
      vim-fugitive
      gitsigns-nvim
      telescope-nvim
      telescope-manix
      rose-pine
      indent-blankline-nvim
    ];
    extraPackages = with pkgs; [
      ripgrep
      git
      fd
      manix
      # language servers
      zls
      csharp-ls
      nil
      alejandra # nix formatter used by nil
      clang-tools
      typescript-language-server
      gopls
      rust-analyzer
      pyright # python types/navigation
      ruff # python lint + format
      lua-language-server
      python3
      imagemagick # for image rendering
    ];
    extraLuaPackages = ps:
      with ps; [
        magick # for image rendering
      ];
    extraPython3Packages = ps:
      with ps; [
        pynvim
        jupyter-client
        cairosvg # for image rendering
        pnglatex # for image rendering
        plotly # for image rendering
        pyperclip
      ];
    initLua = builtins.readFile ./nvim/init.lua;
  };
}
