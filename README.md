# dotfiles

Personal config files for Neovim and tmux.

The guiding idea here is **start from nothing, add only what's essential**, and keep everything understandable at a glance. I want a setup that works out of the box on any machine I sit down at, with no surprises.

## nvim

**Dependency:** [bob](https://github.com/MordechaiHadad/bob) — install it, then `bob install latest && bob use latest`. Bob manages Neovim versions cleanly; no system-level installs needed.

Other than that, the dependency footprint is minimal. Mason pulls language servers on demand, and everything else is fetched by `vim.pack.add()` on first launch.

This config is a learning project — I built it from scratch to understand every line, and it's constantly evolving as I figure out better ways to do things. The config is built on top of the [mini.nvim](https://github.com/nvim-mini/mini.nvim) ecosystem rather than a heavy plugin framework. Mini provides small, focused modules — pick, statusline, completion, pairs, indentscope, textobjects, file explorer, and clue — that each do one thing well without pulling in a hundred dependencies. The statusline is customised to show attached LSP clients and the current time, but stays inside Mini's lightweight framework.

Keymap design follows a simple philosophy: **`<space>` is the leader, and everything lives under logical, mnemonic groups.** `w` for write, `f` for file pick, `g` for grep, `l` for LSP actions, `h` for git hunk/blame. No nesting deeper than two keystrokes, and no obscure chords that require finger gymnastics. If a keybind doesn't feel obvious, it doesn't belong.

Plugins outside the Mini world are kept to a minimum and only included when they solve a real problem:

- **catppuccin** — colorscheme
- **nvim-lspconfig** + **mason.nvim** — LSP management (on-demand, not eager)
- **gitsigns.nvim** — hunk previews and blame
- **lazygit.nvim** — `:LazyGit` (because terminal git is faster than thinking about it)
- **nvim-treesitter** — syntax highlighting (auto-installs parsers)
- **typst-preview.nvim** — live preview for Typst files
- **git-blame.nvim** — inline git blame

## tmux

The tmux config is deliberately conservative. The philosophy is **stay as close to stock as possible** so it works everywhere without surprises.

Changes are minimal and intentional:

- Mouse mode is on — it's expected in 2025.
- The status bar lives on top (where my eyes naturally go).
- True colour is enabled via `tmux-256color`.
- Windows renumber automatically and indexing starts at 1 because counting from 0 is silly in a UI.
- The status bar shows only the session name — nothing else. No clutter, no load averages, no clock (I have a wrist for that).
- Colours are muted greys with a pink accent on the active item — easy on the eyes, no distractions.
- `prefix r` reloads the config in place without restarting the server.
- `allow-rename off` prevents terminal programs from renaming windows (because they shouldn't).

Every change has a clear reason. If it doesn't, it doesn't go in.
