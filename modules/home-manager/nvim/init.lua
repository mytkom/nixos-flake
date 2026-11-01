-- Loaded via programs.neovim.initLua (see ../nvim.nix).
vim.g.mapleader = " "

-- options
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

vim.opt.list = true
vim.opt.listchars = {
  eol = "↴",
  tab = "▸ ",
  trail = "·",
}

-- open files unfolded; folds come from treesitter (see FileType autocmd below)
vim.opt.foldlevelstart = 99

-- diff: pair similar lines, highlight changed characters, hatch deleted lines
vim.opt.diffopt = {
  "internal",
  "filler",
  "closeoff",
  "indent-heuristic",
  "linematch:60",
  "algorithm:histogram",
  "inline:char",
}
vim.opt.fillchars:append({ diff = "╱" })

-- built-in OSC 52 clipboard over SSH (replaces vim-oscyank); locally xclip/wl-copy is used
if vim.env.SSH_TTY then
  vim.g.clipboard = "osc52"
end

-- reload files changed outside nvim (e.g. by a coding agent)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermLeave" }, {
  callback = function()
    if vim.o.buftype ~= "nofile" and vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- remaps
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
vim.keymap.set("v", "<C-c>", [["+y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
if vim.fn.executable("tmux-sessionizer") == 1 then
  vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
end
vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end, { desc = "format buffer (LSP)" })

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- colors
local function trailing_whitespace_hl()
  vim.api.nvim_set_hl(0, "ExtraWhitespace", { bg = "red", ctermbg = "red" })
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = trailing_whitespace_hl })
vim.cmd.colorscheme("rose-pine")

-- `match` is per window, so (re)apply it whenever a buffer is shown in a window
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    if vim.w.trailing_ws_match then
      pcall(vim.fn.matchdelete, vim.w.trailing_ws_match)
      vim.w.trailing_ws_match = nil
    end
    if vim.bo.buftype == "" then
      vim.w.trailing_ws_match = vim.fn.matchadd("ExtraWhitespace", [[\s\+$]])
    end
  end,
})

local highlight = {
  "CursorColumn",
  "Whitespace",
}
require("ibl").setup({
  indent = { highlight = highlight, char = "" },
  whitespace = {
    highlight = highlight,
    remove_blankline_trail = false,
  },
  scope = { enabled = false },
})

-- treesitter: highlight, folds and indent (parsers come from nix withAllGrammars)
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    if pcall(vim.treesitter.start, args.buf) then
      vim.wo[0][0].foldmethod = "expr"
      vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- completion + snippets
local cmp = require("cmp")
local luasnip = require("luasnip")
cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "luasnip" },
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        path = "[Path]",
        luasnip = "[Snip]",
      })[entry.source.name]
      return vim_item
    end,
  },
  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<C-y>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  },
})

-- jump between snippet placeholders (e.g. clangd function arguments)
vim.keymap.set({ "i", "s" }, "<C-l>", function() luasnip.jump(1) end, { silent = true, desc = "snippet: next placeholder" })
vim.keymap.set({ "i", "s" }, "<C-j>", function() luasnip.jump(-1) end, { silent = true, desc = "snippet: previous placeholder" })

-- LSP (server configs ship with nvim-lspconfig; only overrides here)
vim.diagnostic.config({ virtual_text = true, severity_sort = true })

vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.lsp.config("nil_ls", {
  settings = { ["nil"] = { formatting = { command = { "alejandra" } } } },
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
    },
  },
})

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders=1",
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
    semanticHighlighting = true,
  },
})

vim.lsp.enable({ "nil_ls", "gopls", "zls", "csharp_ls", "pyright", "ruff", "ts_ls", "clangd", "lua_ls", "rust_analyzer" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.name == "ruff" then
      client.server_capabilities.hoverProvider = false -- pyright's hover is better
    end

    local builtin = require("telescope.builtin")
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    -- Neovim defaults also apply: K hover, grn rename, gra code action,
    -- grr references, gri implementation, grt type definition, gO symbols,
    -- [d / ]d diagnostics, <C-w>d diagnostic float, <C-s> signature help (insert)
    map("n", "gd", vim.lsp.buf.definition, "go to definition")
    map("n", "<leader>vws", builtin.lsp_dynamic_workspace_symbols, "workspace symbols")
    map("n", "<leader>vs", builtin.lsp_document_symbols, "document symbols")
    map("n", "<leader>vd", vim.diagnostic.open_float, "diagnostic float")
    map("n", "<leader>vca", vim.lsp.buf.code_action, "code action")
    map("n", "<leader>vrr", builtin.lsp_references, "references")
    map("n", "<leader>vrn", vim.lsp.buf.rename, "rename")
    map("i", "<C-h>", vim.lsp.buf.signature_help, "signature help")
  end,
})

-- molten (jupyter); start a kernel explicitly instead of on every python file
if vim.env.KITTY_WINDOW_ID or vim.env.TERM == "xterm-kitty" or vim.env.TERM_PROGRAM == "ghostty" then
  require("image").setup({ backend = "kitty" })
  vim.g.molten_image_provider = "image.nvim"
end

vim.keymap.set("n", "<leader>mi", "<cmd>MoltenInit<cr>", { silent = true, desc = "molten init kernel" })
vim.keymap.set("n", "<leader>mr", "<cmd>MoltenEvaluateOperator<cr>", { silent = true, desc = "run operator selection" })
vim.keymap.set("n", "<leader>ml", "<cmd>MoltenEvaluateLine<cr>", { silent = true, desc = "evaluate line" })
vim.keymap.set("v", "<leader>mv", ":<C-u>MoltenEvaluateVisual<cr>gv", { silent = true, desc = "evaluate visual selection" })
vim.keymap.set("n", "<leader>mc", "<cmd>MoltenReevaluateCell<cr>", { silent = true, desc = "re-evaluate cell" })
vim.keymap.set("n", "<leader>mo", "<cmd>MoltenShowOutput<cr>", { silent = true, desc = "show output" })
vim.keymap.set("n", "<leader>md", "<cmd>MoltenDelete<cr>", { silent = true, desc = "molten delete cell" })
vim.keymap.set("n", "<leader>mh", "<cmd>MoltenHideOutput<cr>", { silent = true, desc = "hide output" })
vim.keymap.set("n", "<leader>ms", ":noautocmd MoltenEnterOutput<cr>", { silent = true, desc = "show/enter output" })

-- harpoon
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)

-- telescope (<C-q> inside a picker sends results to quickfix)
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "find files" })
vim.keymap.set("n", "<leader>ps", builtin.live_grep, { desc = "live grep" })
vim.keymap.set("n", "<leader>pw", builtin.grep_string, { desc = "grep word under cursor" })
vim.keymap.set("n", "<leader>pb", builtin.buffers, { desc = "buffers" })
vim.keymap.set("n", "<leader>po", builtin.oldfiles, { desc = "recent files" })
vim.keymap.set("n", "<leader>pr", builtin.resume, { desc = "resume last picker" })
vim.keymap.set("n", "<leader>pg", builtin.git_status, { desc = "git status with diff preview" })
vim.keymap.set("n", "<leader>pc", builtin.git_bcommits, { desc = "commits touching this file" })
vim.keymap.set("n", "<leader>pd", builtin.diagnostics, { desc = "diagnostics" })
vim.keymap.set("n", "<leader>ph", builtin.help_tags, { desc = "help tags" })
vim.keymap.set("n", "<leader>pk", builtin.keymaps, { desc = "keymaps" })
vim.keymap.set("n", "<leader>pm", "<cmd>Telescope manix<cr>", { desc = "nix docs (manix)" })

-- fugitive
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "git status" })
vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "git blame (file)" })
vim.keymap.set("n", "<leader>gd", "<cmd>Gvdiffsplit<cr>", { desc = "diff file vs index" })
vim.keymap.set("n", "<leader>gD", "<cmd>Gvdiffsplit HEAD<cr>", { desc = "diff file vs HEAD" })
vim.keymap.set("n", "<leader>gt", "<cmd>Git difftool -y<cr>", { desc = "unstaged changes, one diff tab per file" })
vim.keymap.set("n", "<leader>gq", "<cmd>Git difftool<cr>", { desc = "unstaged hunks to quickfix" })
vim.keymap.set("n", "<leader>gl", "<cmd>0Gclog<cr>", { desc = "file history to quickfix" })
vim.keymap.set("n", "<leader>gL", "<cmd>Gclog -100<cr>", { desc = "repo history to quickfix" })
vim.keymap.set("n", "<leader>gw", "<cmd>Gwrite<cr>", { desc = "stage file" })
vim.keymap.set("n", "<leader>ga", "<cmd>Git add -A<cr>", { desc = "stage everything (review baseline)" })

-- gitsigns (line blame replaces git-blame.nvim)
require("gitsigns").setup({
  current_line_blame = true,
  current_line_blame_opts = { delay = 300 },
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- in diff mode keep native ]c / [c
    map("n", "]c", function()
      if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end
    end, "next hunk")
    map("n", "[c", function()
      if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end
    end, "previous hunk")

    map("n", "<leader>hs", gs.stage_hunk, "stage/unstage hunk")
    map("n", "<leader>hr", gs.reset_hunk, "reset hunk")
    map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "stage lines")
    map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "reset lines")
    map("n", "<leader>hS", gs.stage_buffer, "stage buffer")
    map("n", "<leader>hR", gs.reset_buffer, "reset buffer")
    map("n", "<leader>hp", gs.preview_hunk_inline, "preview hunk inline")
    map("n", "<leader>hP", gs.preview_hunk, "preview hunk in float")
    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "blame line (full commit)")
    map("n", "<leader>hd", gs.diffthis, "diff vs index")
    map("n", "<leader>hq", function() gs.setqflist("all") end, "all hunks in repo to quickfix")
    map("n", "<leader>hQ", gs.setqflist, "buffer hunks to quickfix")
    map("n", "<leader>hc", function()
      vim.ui.input({ prompt = "Diff signs against revision: " }, function(rev)
        if rev and rev ~= "" then gs.change_base(rev, true) end
      end)
    end, "change base revision (all buffers)")
    map("n", "<leader>hC", function() gs.reset_base(true) end, "reset base revision")
    map("n", "<leader>tb", gs.toggle_current_line_blame, "toggle line blame")
    map("n", "<leader>tw", gs.toggle_word_diff, "toggle word diff")
    map({ "o", "x" }, "ih", gs.select_hunk, "hunk text object")
  end,
})
