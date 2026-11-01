# Neovim keybindings & workflows

Oct 1, 2026 · @Marek

## Mental model

Leader is Space, and every leader binding sits under a one-letter area. Learn the six letters and the rest follows. Typing `<Space>pk` searches every mapping by its description, so forgetting a key costs four keystrokes.

| Prefix | Area | Think of it as |
| --- | --- | --- |
| `<leader>p` | Telescope pickers, plus `pv` for the file explorer | **p**ick |
| `<leader>v` | LSP actions in code buffers | **v**iew code |
| `<leader>g` | Repo-level git (fugitive) | **g**it |
| `<leader>h` | One hunk or one buffer (gitsigns) | **h**unk |
| `<leader>t` | Toggles: `tb` line blame, `tw` word diff | **t**oggle |
| `<leader>m` | Molten (Jupyter) | **m**olten |

Single-key leaders: `a` harpoon add, `f` format, `s` substitute the word under the cursor, `u` undotree, `x` chmod +x, `y`/`Y` yank to the system clipboard, `d` delete without yanking, `p` (visual) paste without losing the register, `j`/`k` location list previous/next.

### Built-in Neovim 0.12 keys you get for free

These need no config and work in every LSP buffer.

| Key | Mode | Action |
| --- | --- | --- |
| `K` | normal | Hover docs |
| `grn` | normal | Rename symbol |
| `gra` | normal, visual | Code action |
| `grr` | normal | References |
| `gri` | normal | Implementation |
| `grt` | normal | Type definition |
| `gO` | normal | Document symbols |
| `[d` / `]d` | normal | Previous / next diagnostic |
| `[D` / `]D` | normal | First / last diagnostic |
| `<C-w>d` | normal | Diagnostic float |
| `<C-s>` | insert | Signature help |
| `[q` / `]q` | normal | Previous / next quickfix entry |
| `[b` / `]b` | normal | Previous / next buffer |
| `an` / `in` | visual | Grow / shrink selection to the enclosing syntax node |
| `gx` | normal | Open the link or path under the cursor |

## Navigation and editing

Use harpoon for the 2 to 4 files you edit right now, Telescope for everything else, and quickfix to step through any list of locations.

### Harpoon (your working set)

| Key | Action |
| --- | --- |
| `<leader>a` | Mark the current file |
| `<C-e>` | Open the mark list; reorder or delete lines like normal text |
| `<C-h>` `<C-t>` `<C-n>` `<C-s>` | Jump to mark 1, 2, 3, 4 |

### Telescope pickers

| Key | Picker | Reach for it when |
| --- | --- | --- |
| `<leader>pf` | Files | You know the file name |
| `<leader>ps` | Live grep | You know some text in the file |
| `<leader>pw` | Grep the word under the cursor | You want every use of a name, without typing it |
| `<leader>pb` | Open buffers | You opened it a minute ago (was `<leader>fb`) |
| `<leader>po` | Recent files | You opened it yesterday |
| `<leader>pr` | Resume the last picker, with its query and position | You jumped to a result and want the next one |
| `<leader>pg` | Git status with diff preview | First look at what changed |
| `<leader>pc` | Commits touching this file, with diff preview | When and why did this file change |
| `<leader>pd` | Diagnostics | Errors across open buffers |
| `<leader>ph` | Help tags | Any `:help` topic |
| `<leader>pk` | Keymaps | You forgot a key |
| `<leader>pm` | Nix docs (manix) | Editing this flake |

Inside any picker: `<C-n>`/`<C-p>` move, `<CR>` open, `<C-v>` vertical split, `<C-x>` horizontal split, `<Tab>` select multiple, `<C-q>` send all results to quickfix, `<M-q>` send only the selected ones.

### Quickfix: one list, every tool feeds it

`<C-k>` jumps to the next entry and `<C-j>` to the previous one, centred. `:copen` shows the list and `:cclose` hides it. Fugitive difftool, gitsigns hunks, Telescope `<C-q>` and LSP references all land here, so these two keys walk any result set.

Fastest "visit every use of this name": cursor on the word, then `<leader>pw` `<C-q>` `<C-k>` `<C-k>` `<C-k>`

### Editing remaps

| Key | Mode | Action |
| --- | --- | --- |
| `J` / `K` | visual | Move the selected lines down / up and reindent |
| `J` | normal | Join lines without moving the cursor |
| `<C-d>` / `<C-u>`, `n` / `N` | normal | Scroll or search, cursor kept centred |
| `<leader>s` | normal | Replace the word under the cursor in the whole file; type the new name and press Enter |
| `<leader>p` | visual | Paste over the selection without losing the yanked text |
| `<leader>y` / `<leader>Y` | normal, visual | Yank to the system clipboard (OSC 52 over SSH) |
| `<C-c>` | visual | Same as `<leader>y` |
| `<leader>d` | normal, visual | Delete without overwriting the register |
| `<leader>u` | normal | Undotree: browse every undo branch, including reloads after an agent edit |
| `<leader>pv` | normal | netrw file explorer |

Folds come from treesitter and every file opens unfolded. Use `zc`/`zo` to close or open one fold, `zM`/`zR` for all, and `za` to toggle.

## LSP, completion and snippets

Your old `<leader>v…` keys still work, and the built-in `gr…` keys do the same things. Use whichever your fingers prefer.

| Key | Action | Built-in equivalent |
| --- | --- | --- |
| `gd` | Go to definition (`<C-o>` jumps back) |  |
| `K` | Hover docs; press again to enter the float |  |
| `<leader>vrr` | References in Telescope with preview | `grr` puts them in quickfix |
| `<leader>vrn` | Rename symbol across the project | `grn` |
| `<leader>vca` | Code action (imports, quick fixes) | `gra` |
| `<leader>vs` | Symbols in this file, in Telescope | `gO` puts them in the location list |
| `<leader>vws` | Symbols across the workspace, live |  |
| `<leader>vd` | Show the full diagnostic under the cursor | `<C-w>d` |
| `]d` / `[d` | Next / previous diagnostic (now in the right direction) |  |
| `<leader>f` | Format the buffer |  |
| `<C-h>` (insert) | Signature help | `<C-s>` |

Diagnostics show at the end of the line again (Neovim 0.11 hid them by default).

### Formatter per language for `<leader>f`

| Language | Formats with |
| --- | --- |
| Python | ruff (pyright does types and navigation) |
| Nix | alejandra, through nil |
| Go | gopls |
| C / C++ | clangd |
| TypeScript / JavaScript | ts\_ls |
| Lua | lua\_ls |
| Zig | zls |

### Completion menu (insert mode)

| Key | Action |
| --- | --- |
| `<C-Space>` | Open the menu |
| `<C-n>` / `<C-p>` | Next / previous item |
| `<C-y>` | Accept the item |
| `<C-e>` | Close the menu |
| `<C-f>` / `<C-b>` | Scroll the docs window |

### Snippet placeholders (new)

Accepting a function from clangd or gopls inserts its arguments as placeholders. `<C-l>` jumps to the next placeholder and `<C-j>` to the previous one, in insert or select mode. Typing replaces the selected placeholder.

Fastest call: type `fo`, then `<C-n>` `<C-y>`, type the first argument, `<C-l>`, type the second argument.

## Git with fugitive

The status buffer (`<leader>gs`) is the hub: almost every git action is one key from there. Press `g?` inside it for the full list.

### Global keys

| Key | Action |
| --- | --- |
| `<leader>gs` | Status buffer |
| `<leader>gd` | Side-by-side diff of this file against the index (staged state) |
| `<leader>gD` | Side-by-side diff of this file against HEAD |
| `<leader>gt` | Every unstaged file in its own tab as a side-by-side diff |
| `<leader>gq` | Every unstaged hunk in quickfix; walk them with `<C-k>` |
| `<leader>gb` | Blame the whole file in a side column |
| `<leader>gl` | Every past version of this file in quickfix; `<C-k>` steps back in time |
| `<leader>gL` | Last 100 repo commits in quickfix |
| `<leader>gw` | Stage the current file (`:Gwrite`) |
| `<leader>ga` | Stage everything (`:Git add -A`); this is the review baseline in the agent flow |

Useful commands with no mapping: `:Gread` resets the buffer to the index version (undo with `u`). `:Gedit HEAD~3:%` opens this file as it was three commits ago. `:Git difftool -y main` diffs every file against `main`.

### Inside the status buffer

| Key | Action |
| --- | --- |
| `s` / `u` / `-` | Stage / unstage / toggle the file or hunk under the cursor; in visual mode, only the selected lines |
| `U` | Unstage everything |
| `X` | Discard the change under the cursor. It echoes the command to undo it. On an untracked file it **deletes** the file |
| `=` | Toggle the inline diff of the file |
| `]c` / `[c` | Next / previous hunk, expanding inline diffs as it goes |
| `)` / `(` | Next / previous file or hunk |
| `i` | Next file or hunk, expanding |
| `gu` / `gU` / `gs` | Jump to the Untracked, Unstaged or Staged section |
| `dv` | Side-by-side diff of the file; `dq` closes it again |
| `<CR>` / `o` / `gO` / `O` | Open the file here / in a split / in a vertical split / in a tab |
| `cc` | Commit (write the message, then `:wq`) |
| `ca` / `ce` / `cw` | Amend and edit the message / amend without editing / reword the last commit |
| `czz` / `czp` | Stash / pop the stash |
| `I` | `git add --patch` on the file |
| `g?` | Help |

### Inside blame (`<leader>gb`)

| Key | Action |
| --- | --- |
| `<CR>` | Open the commit that added the line |
| `o` / `O` | Open the commit in a split / new tab |
| `p` | Preview the commit |
| `-` | Re-blame at that commit (go further back in time) |
| `gq` | Close blame |

The faint text at the end of the current line is gitsigns line blame. It replaced git-blame.nvim with the same look. `<leader>tb` toggles it.

## Git hunks with gitsigns

Gitsigns works inside the file you are editing. Use it when you are already looking at the code and want to act on one change without opening status.

| Key | Mode | Action |
| --- | --- | --- |
| `]c` / `[c` | normal | Next / previous hunk (native diff jump when in diff mode) |
| `<leader>hp` | normal | Preview the hunk inline: the old lines appear above the new ones |
| `<leader>hP` | normal | Preview the hunk in a float |
| `<leader>hs` | normal | Stage the hunk; on an already staged hunk it unstages |
| `<leader>hs` | visual | Stage only the selected lines |
| `<leader>hr` | normal, visual | Reset the hunk or the selected lines to the index version (undo with `u`) |
| `<leader>hS` / `<leader>hR` | normal | Stage / reset the whole buffer |
| `<leader>hb` | normal | Blame the line with the full commit message |
| `<leader>hd` | normal | Side-by-side diff of this buffer against the index |
| `<leader>hq` | normal | Every hunk in the repo to quickfix |
| `<leader>hQ` | normal | This buffer's hunks to quickfix |
| `<leader>hc` | normal | Prompt for a revision, e.g. `main` or `HEAD~3`; all signs then show changes since it |
| `<leader>hC` | normal | Back to the normal base |
| `<leader>tw` | normal | Toggle word-level highlight of changes in the buffer |
| `<leader>tb` | normal | Toggle end-of-line blame |
| `ih` | operator, visual | The hunk as a text object: `vih` selects it, `dih` deletes it, `yih` yanks it |

Fastest "what did I change in this file?": `]c` `<leader>hp` `]c` `<leader>hp`

Fastest "throw away this experiment": `<leader>hR`, then `u` if you regret it.

## Diff mode

Side-by-side diffs (`dv`, `<leader>gd`, `<leader>gt`) now highlight the exact changed characters, not the whole line. Use them for real reading; use the inline `=` diff for quick triage.

What the new settings change:

- `inline:char` highlights only the characters that changed inside a modified line (new in Neovim 0.12).
- `linematch:60` pairs each old line with its most similar new line, so a hunk that edits three lines shows three paired lines, not a block of red and a block of green.
- `algorithm:histogram` and `indent-heuristic` give fewer odd matches when code is moved or reindented.
- Deleted lines show as hatched `╱╱╱` filler, not `-----`.

| Key | Action |
| --- | --- |
| `]c` / `[c` | Next / previous change |
| `do` | Take the hunk from the other side (diff obtain) |
| `dp` | Put this hunk into the other side (diff put) |
| `zo` / `zc` / `zR` | Unchanged regions are folded: open one / close one / open all |
| `:diffupdate` | Recompute the diff after editing |
| `dq` | In a fugitive diff: close the other diff windows and leave diff mode |
| `gt` / `gT` | Next / previous tab, e.g. the next file after `<leader>gt` |
| `:tabonly` | Close all difftool tabs at once |

In `<leader>gd`, the left window is the index and the right is your working file. `dp` from the right stages that hunk into the left buffer, which you then save with `:w`. In practice, staging from status (`s`) or gitsigns (`<leader>hs`) is faster.

## Flow: reviewing AI agent changes

Use the git index as your approval stamp. Stage what you accept, discard what you reject, and on the next agent round only the new changes show as unstaged. VS Code shows everything since HEAD; this shows only what you have not reviewed yet.

&#91;embedded content: agent review loop · the git index is your approval marker\]

### One-time per task

1. Before prompting the agent, press `<leader>ga` in Neovim. Everything is now staged and that is your baseline. (Or commit, if you prefer real checkpoints.)
2. Let the agent work in its own terminal. When you come back to Neovim, open buffers reload on focus or on buffer switch. If a buffer was reloaded, `u` undoes the agent's change in it.

### Fast pass: triage every hunk (the default)

`<leader>gs` `]c`, then for each hunk press `s` (keep) or `X` (drop), and `]c` again to skip a hunk you want to look at later.

- `]c` jumps into the Unstaged section and opens the inline diff of the hunk.
- To keep only part of a hunk: `V`, select the good lines, `s`.
- New files appear under Untracked. `s` accepts them; `X` on an untracked file deletes it.
- When Unstaged is empty, the round is done.

`]c` keeps going into the Staged section once Unstaged is done. When the cursor lands on a Staged hunk, stop: those are hunks you already approved.

### Careful pass: side-by-side with character highlights

Use this when a hunk is too big to judge inline.

1. In status, cursor on the file, `dv`.
2. `]c` / `[c` jump between changes; changed characters are highlighted.
3. `dq` closes the diff and returns you to status, where you press `s` or `X`.

For a whole change set at once: `<leader>gt` opens every unstaged file in its own tab. Move with `gt` / `gT` and close everything with `:tabonly`.

### From inside the code

If you are already reading a file, you do not need status: `]c` to the next hunk, `<leader>hp` to see what changed, `<leader>hs` to keep, `<leader>hr` to revert. `<leader>hq` puts every hunk in the repo into quickfix; walk them with `<C-k>`.

### When the agent made commits

The index trick does not see changes that are already committed. Diff against the branch point instead:

- `:Git difftool -y main` opens one tab per file changed since `main`.
- `<leader>hc`, type `main` (or the SHA before the agent started), Enter. The gutter signs everywhere now show changes since that revision, and `<leader>hq` lists them. `<leader>hC` goes back to normal.
- `<leader>pg` gives a quick overview of changed files with a diff preview.

### Finish

When the task is done: `<leader>gs` `cc`, write the message, `:wq`. If more work is needed, send the agent the next prompt; what you staged stays as the new baseline.

## Other flows

### Rename or replace across the project

- **A code symbol:** cursor on it, `grn` (or `<leader>vrn`), type the new name, Enter. The LSP updates every reference.
- **Plain text across files:** `<leader>ps`, type the text, `<C-q>`, then `:cdo s/old/new/g | update`. Each match is replaced and its file saved. Check first with `<C-k>` if unsure.
- **Inside one file:** cursor on the word, `<leader>s`, type the new name, Enter.

### Why does this line look like this?

1. `<leader>hb` shows the commit message for the current line in a float. This is usually enough.
2. If you need more context: `<leader>gb` for full-file blame, then `<CR>` on the line to open the commit.
3. To go further back: `-` in blame re-blames at that commit.
4. For the file's whole story: `<leader>gl`, then `<C-k>` repeatedly. Each step shows the file at an older commit. `<leader>pc` gives the same list with a diff preview.

### Merge or rebase conflict

1. `<leader>gs`, then move the cursor to a conflicted file (status letter U).
2. Cursor on a file: `dv` opens a three-way diff. The left is ours, the middle is the result, the right is theirs.
3. In the middle window, `]c` to each conflict, then `d2o` to take ours or `d3o` to take theirs. Edit by hand if neither fits.
4. `:Gwrite` marks the file resolved, then `dq`.
5. To take one side for the whole file without looking: `2X` (ours) or `3X` (theirs) in status.

### Jupyter-style cells with molten

1. Open a `.py` file, then `<leader>mi` and pick a kernel. This no longer runs on every Python file.
2. `<leader>ml` runs the line. `<leader>mr` plus a motion runs that range, e.g. `<leader>mrip` for the paragraph. `<leader>mv` runs a visual selection.
3. `<leader>mc` re-runs the cell under the cursor and `<leader>md` deletes it.
4. `<leader>mo` shows the output, `<leader>ms` enters the output window (to scroll or copy), `<leader>mh` hides it.

Plots render only in a kitty-graphics terminal (kitty, Ghostty). Alacritty cannot show images, so there you get text output only.

## What changed in the config

Neovim went from 0.10.4 to 0.12.5 (nixpkgs and home-manager locked to 2026-09-29 and 2026-10-01). The Lua config now lives in `modules/home-manager/nvim/init.lua`, loaded through `initLua`, so lua\_ls helps when you edit it.

**Keys that moved**

| Old | New | Why |
| --- | --- | --- |
| `<leader>fb` | `<leader>pb` | `<leader>f` (format) waited 1 s for a possible `fb` |
| `<leader>mrr` | `<leader>mc` | `<leader>mr` waited 1 s for a possible `mrr` |
| `MoltenInit` on every Python file | `<leader>mi` | It prompted for a kernel on every Python file you opened |
| `<leader>mv` | same key, now works | It scrolled half a page instead of running the selection |
| `[d` / `]d` | same keys, built-in | They were swapped |
| `<C-f>` tmux-sessionizer | only if the script exists | tmux and the script are not installed here |

**Fixes**

- Treesitter folds work now. Before, `foldmethod` was never set to `expr`, so nothing folded.
- Treesitter and LSP moved to the 0.12 APIs: `vim.treesitter.start` and `vim.lsp.config` / `vim.lsp.enable`. The old ones error or warn after the update.
- New servers: `ts_ls` (the TypeScript server was installed but never started), `ruff` for Python formatting, `lua_ls`. nil now formats with alejandra.
- clangd failed to start on clang 21. `--function-arg-placeholders` now needs `=1`.
- Snippet placeholders can be jumped with `<C-l>` / `<C-j>`.
- Files changed outside Neovim reload when Neovim gets focus or you switch buffers.
- Trailing-whitespace red highlight now applies in every window and survives colorscheme reloads.
- image.nvim is set up only in kitty-graphics terminals.

**Removed:** git-blame.nvim (replaced by gitsigns line blame), vim-oscyank (built-in OSC 52 over SSH), vim-nix (treesitter plus nil cover it), and the duplicate nvim-cmp entry.

**Outside Neovim:** `zsh.nix` swaps `neofetch` (removed from nixpkgs) for `fastfetch`, and `initExtra` for `initContent`.

**Other hosts:** the flake lock is shared, and the other hosts no longer evaluate on the new nixpkgs:

- old-bunny and levicorpus home configs: `jetbrains.pycharm-professional` was renamed to `jetbrains.pycharm`.
- old-bunny and levicorpus NixOS: `gnome-photos` was removed.
- esprimo NixOS: `services.samba.extraConfig` has to become `services.samba.settings`.

Those machines keep running until you rebuild them, and more errors may appear once these are fixed.
