-- General options
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.signcolumn = 'yes'
vim.opt.winborder = 'rounded'
vim.opt.clipboard = 'unnamedplus'
vim.opt.swapfile = false
vim.opt.scrolloff = 15
vim.g.mapleader = " "

-- General keymaps
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>', { desc = 'S[o]urce config' })
vim.keymap.set('n', '<leader>w', ':update<CR>', { desc = '[W]rite file' })
vim.keymap.set('n', '<leader>q', ':quit<CR>', { desc = '[Q]uit' })
vim.keymap.set('n', '<leader>r', "<Cmd>Pick buffers<Cr>", { desc = '[r]ecent buffers' })
vim.keymap.set('n', '<leader>f', "<Cmd>Pick files<Cr>", { desc = 'pick [f]iles' })
vim.keymap.set('n', '<leader>g', "<Cmd>Pick grep_live<Cr>", { desc = '[g]rep (live)' })
vim.keymap.set('n', '<leader>v', '<Cmd>e $MYVIMRC<CR>', { desc = "[v]imrc" })
vim.keymap.set('n', '<leader>c', ':bdelete<CR>', { desc = '[c]lose buffer' })
vim.keymap.set('n', '<leader><leader>', '<Cmd>b#<CR>', { desc = 'Switch to last buffer' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Git related (hunks + lazygit)
vim.keymap.set('n', '<leader>hp', "<cmd>Gitsigns preview_hunk<CR>", { desc = "[P]review Git Hunk" })
vim.keymap.set('n', '<leader>hb', "<cmd>Gitsigns blame_line<CR>", { desc = "[B]lame Current Line" })
vim.keymap.set('n', '<leader>hn', "<cmd>Gitsigns next_hunk<CR>", { desc = "Git Hunk [n]ext" })
vim.keymap.set('n', '<leader>hN', "<cmd>Gitsigns prev_hunk<CR>", { desc = "Git Hunk  Previous" })
vim.keymap.set('n', '<leader>hg', '<cmd>LazyGit<CR>', { desc = 'Open lazy[g]it' })

-- Mini.files explorer
vim.keymap.set('n', '<leader>e', function() require('mini.files').open() end, { desc = 'open [e]xplorer' })

-- Visual feedback on yank
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
	end,
})

-- Plugins (and colorschemes)
vim.pack.add({
	-- Colorschemes
	--	{ src = "https://github.com/vague-theme/vague.nvim" },
	--	{ src = "https://github.com/dracula/vim" },
	{ src = "https://github.com/catppuccin/nvim" },
	-- Plugins
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
})

-- Set colorscheme
vim.cmd.colorscheme('catppuccin-frappe')

-- Set up mini plugins
require "mini.completion".setup()	-- LSP-based completion
require "mini.pick".setup()				-- Fuzzy finder (files, buffers, grep)
require "mini.icons".setup()			-- Icons for UI elements
require "mini.git".setup()				-- Lightweight Git integration (statusline)
require "mini.pairs".setup()			-- Auto-close brackets/quotes
require "mini.indentscope".setup()-- Indent scopes
require "mini.ai".setup()					-- Smart textobjects (functions, classes, ...)
require "mini.files".setup()			-- File explorer (like oil.nvim, in here to auto-open on 'nvim .')

-- Custom statusline with attached LSP & time
local MiniStatusline = require("mini.statusline")

MiniStatusline.setup({
	content = {
		active = function()
			local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
			local git           = MiniStatusline.section_git({ trunc_width = 40 })
			local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
			local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
			local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
			local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
			-- local location      = MiniStatusline.section_location({ trunc_width = 75 })
			-- local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

			-- Custom LSP part
			local clients       = vim.lsp.get_clients({ bufnr = 0 })
			local names         = {}
			for _, client in ipairs(clients) do
				table.insert(names, client.name)
			end
			local lsp = #names > 0 and ("\u{f013} " .. table.concat(names, ", ")) or " None"

			-- Custom Time
			local time = os.date("%H:%M")

			return MiniStatusline.combine_groups({
				{ hl = mode_hl,                 strings = { mode } },
				{ hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics } },
				'%<',
				{ hl = 'MiniStatuslineFilename', strings = { filename } },
				'%=',
				{ hl = 'MiniStatuslineFilename', strings = { lsp } },
				{ hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
				{ hl = mode_hl,                  strings = { time } },
				-- { hl = mode_hl,                  strings = { search, location } },
			})
		end,
	}
})

require "mini.clue".setup({
	triggers = {
		{ mode = 'n', keys = '<Leader>' },
	}
})

-- LSP Configutation: Mason downloads -> vim.lsp.enable() → vim.lsp.config() overrides (if needed) -> LspAttach keymaps
-- Show diagnostics inline
vim.diagnostic.config({ virtual_text = true })

-- :Mason for manual downloads
require "mason".setup()

-- Enable LSP servers
vim.lsp.enable({ "lua_ls", "ruff", "ty", "pyright", "clangd", "jdtls", "ts_ls", "tinymist", "gopls" })

-- Custom settings for LSPs
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" } }
		}
	}
})

vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--clang-tidy",
	},
})

vim.lsp.config("tinymist", {
	cmd = { "tinymist" },
	filetypes = { "typst" },
	formatterMode = "typstyle"
})

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('LspConfig', { clear = true }),
	desc = 'LSP actions',
	callback = function(event)
		-- Create buffer-local keymaps for the current buffer
		local map = function(keys, func, desc)
			vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
		end
		-- Buffer-local LSP keymaps
		map('<leader>lf', vim.lsp.buf.format, '[f]ormat')
		map('<leader>ld', vim.lsp.buf.definition, '[d]efinition')
		map('<leader>lr', vim.lsp.buf.references, '[r]eferences')
		map('<leader>ln', vim.lsp.buf.rename, 're[n]ame')
		map('<leader>la', vim.lsp.buf.code_action, 'code [a]ction (how to fix)')
		map('<leader>le', vim.diagnostic.open_float, '[e]rror diagnostics')
		map('<leader>lh', vim.lsp.buf.hover, '[h]over documentation')
		-- map('<leader>li', vim.lsp.buf.implementation, '[i]mplementation')
	end,
})

-- Treesitter config
require('nvim-treesitter.configs').setup({
	auto_install = true,
	highlight = {
		enable = true,
	},
})
