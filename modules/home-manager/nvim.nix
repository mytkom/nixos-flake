{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      (nvim-treesitter.withAllGrammars)
      vim-nix
      nvim-compe
      luasnip
      harpoon
      plenary-nvim
      undotree
      vim-fugitive
      telescope-nvim
      telescope-manix
      rose-pine
      indent-blankline-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      vim-oscyank
      gitsigns-nvim
    ];
    extraPackages = with pkgs; [
      ripgrep
      git
      fd
      zls
      csharp-ls
      manix
      nil
      clang-tools
      nodePackages.typescript-language-server
      gopls
    ];
    extraConfig = ''
        set foldexpr=nvim_treesitter#foldexpr()

        lua << EOF
        -- remaps
        vim.g.mapleader = " "
        vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

        vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
        vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

        vim.keymap.set("n", "J", "mzJ`z")
        vim.keymap.set("n", "<C-d>", "<C-d>zz")
        vim.keymap.set("n", "<C-u>", "<C-u>zz")
        vim.keymap.set("n", "n", "nzzzv")
        vim.keymap.set("n", "N", "Nzzzv")

        vim.keymap.set("x", "<leader>p", [["_dP]])

        vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
        vim.keymap.set("n", "<leader>Y", [["+Y]])

        vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

        vim.keymap.set("n", "Q", "<nop>")
        vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

        vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
        vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
        vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
        vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

        vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
        vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

        vim.cmd.colorscheme "rose-pine"

        local actions = require('telescope.actions')
        require('gitsigns').setup()

        require'nvim-treesitter.configs'.setup {
          indent = {
            enable = true
          },
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
        }

        local highlight = {
            "CursorColumn",
            "Whitespace",
        }
        require("ibl").setup {
            indent = { highlight = highlight, char = "" },
            whitespace = {
                highlight = highlight,
                remove_blankline_trail = false,
            },
            scope = { enabled = false },
        }

        vim.cmd[[
          match ExtraWhitespace /\s\+$/
          highlight ExtraWhitespace ctermbg=red guibg=red
        ]]

        vim.opt.list = true
        vim.opt.listchars = {
            eol = "↴",
            tab = '▸ ',
            trail = '·'
        }

        -- LSP + nvim-cmp setup
        local cmp = require("cmp")
        cmp.setup {
          sources = {
            { name = "nvim_lsp" },
            { name = "path" },
            { name = "luasnip" },
          },
          snippet = {
            expand = function(args)
              require'luasnip'.lsp_expand(args.body)
            end
          },
          formatting = {
            format = function(entry, vim_item)
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                path = "[Path]",
              })[entry.source.name]
              return vim_item
            end
          },
          mapping = {
            ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),
            ['<C-y>'] = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            })
          },
        }

        local on_attach = function(client, bufnr)
          local opts = {buffer = bufnr, remap = false}

          vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
          vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
          vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
          vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
          vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
          vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
          vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
          vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
          vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
          vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        end

        local lspconfig = require("lspconfig");
        local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities());
        local servers = { 'nil_ls', 'tsserver', 'gopls', 'zls', 'csharp_ls' }
        for _, lsp in ipairs(servers) do
          lspconfig[lsp].setup {
            capabilities = capabilities,
            on_attach = on_attach,
          }
        end

        lspconfig["clangd"].setup {
          capabilities = capabilities,
          filetypes = { "c", "cpp", "objc", "objcpp", "hpp", "cu", "cuh", "h" },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders"
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
            semanticHighlighting = true
          },
          on_attach = on_attach,
          flags = { debounce_text_changes = 150 }
        }


        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")
        vim.keymap.set('n', "<leader>a", mark.add_file)
        vim.keymap.set('n', "<C-e>", ui.toggle_quick_menu)
        vim.keymap.set('n', "<C-h>", function() ui.nav_file(1) end)
        vim.keymap.set('n', "<C-t>", function() ui.nav_file(2) end)
        vim.keymap.set('n', "<C-n>", function() ui.nav_file(3) end)
        vim.keymap.set('n', "<C-s>", function() ui.nav_file(4) end)

        vim.keymap.set('n', "<leader>gs", vim.cmd.Git)

        vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

        vim.opt.nu = true
        vim.opt.relativenumber = true

        vim.opt.tabstop = 2
        vim.opt.softtabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.expandtab = true

        vim.opt.smartindent = true

        vim.opt.wrap = false

        vim.opt.swapfile = false
        vim.opt.backup = false
        vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
        vim.opt.undofile = true

        vim.opt.hlsearch = false
        vim.opt.incsearch = true

        vim.opt.termguicolors = true

        vim.opt.scrolloff = 8
        vim.opt.signcolumn = "yes"
        vim.opt.isfname:append("@-@")

        vim.opt.updatetime = 50

        vim.opt.colorcolumn = "80"

        EOF

        " Configure Telescope
        " Find files using Telescope command-line sugar.
        nnoremap <leader>pf <cmd>Telescope find_files<cr>
        nnoremap <leader>ps <cmd>Telescope live_grep<cr>
        nnoremap <leader>fb <cmd>Telescope buffers<cr>

        vmap <C-c> y:OSCYankVisual<cr>

    '';
  };
}
