---------------------------------------

-- TODO: add markdown viewier plugin
-- TODO: better hover documentation

---------------------------------------
-- #OPTIONS / SETTINGS
---------------------------------------

vim.g.mapleader      = " "
vim.g.maplocalleader = " "
vim.g.ghostty        = (vim.env.TERM_PROGRAM == "ghostty")
vim.g.kitty          = (vim.env.TERM_PROGRAM == "kitty")
vim.g.blend          = vim.g.neovide and 0
vim.g.border         = "rounded"

-- Window
vim.o.equalalways    = true
vim.o.winwidth       = 10
vim.o.winminwidth    = 10
vim.o.splitbelow     = true
vim.o.splitright     = true
vim.o.wrap           = false
vim.o.termguicolors  = true
vim.o.fillchars      = "eob: "

-- Blending / Opacity
vim.o.winblend       = vim.g.blend
vim.o.pumblend       = vim.g.blend
vim.o.winblend       = vim.g.blend
vim.o.pumblend       = vim.g.blend

-- File handling
vim.o.confirm        = true
vim.o.autoread       = true
vim.o.swapfile       = false
vim.o.backup         = false
vim.o.undofile       = true
vim.o.exrc           = true

-- Search
vim.o.wildignorecase = true
vim.o.wildoptions    = "pum,fuzzy"
vim.o.wildmode       = "longest:full,full"

-- Tab
vim.o.smartindent    = true
vim.o.tabstop        = 2
vim.o.softtabstop    = 2
vim.o.shiftwidth     = 2
vim.o.expandtab      = true

-- Statusline
vim.o.laststatus     = 0
vim.o.cmdheight      = 0

-- Statuscolumn
vim.o.number         = true
vim.o.relativenumber = true
vim.o.cursorline     = true
vim.o.cursorlineopt  = "number"
vim.o.foldcolumn     = "0"
vim.o.signcolumn     = "yes:1"
vim.o.statuscolumn   = " %= %{v:relnum ? printf('%3d', v:relnum) : printf('%3d', v:lnum)} %s "

-- Global clipboard
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	jump = { float = true },
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	virtual_text = false,
	virtual_lines = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚",
			[vim.diagnostic.severity.WARN]  = "󰀦",
			[vim.diagnostic.severity.HINT]  = "󰌶",
			[vim.diagnostic.severity.INFO]  = "󰋽",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
			[vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
			[vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
			[vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
		},
	},
})

---------------------------------------
-- #CONST
---------------------------------------
local DATA = vim.fn.stdpath("data")
local PLUGIN_DATA = DATA .. "/site/pack/core/opt"

---------------------------------------
-- #AUTOCMD / #ON_KEY
---------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	group = vim.api.nvim_create_augroup("highlight_on_word", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.opt_local.winbar = ""
		vim.opt_local.relativenumber = false
		vim.opt_local.number = false
		vim.opt_local.statuscolumn = ""
		vim.cmd("startinsert")
	end
})

vim.on_key(function(char)
	if vim.fn.mode() == "n" then
		local key = vim.fn.keytrans(char)
		local search_keys = { "n", "N", "/", "?", "*", "#" }
		vim.o.hlsearch = vim.tbl_contains(search_keys, key)
	end
end, vim.api.nvim_create_namespace("auto_hlsearch"))

---------------------------------------
-- #COMMANDS
---------------------------------------
vim.api.nvim_create_user_command("VTerm", function()
	vim.cmd("vsplit | terminal")
end, {})

vim.api.nvim_create_user_command("HTerm", function()
	vim.cmd("split | terminal")
end, {})

---------------------------------------
-- #FUNCTION / #MACROS
---------------------------------------
local function better_search(key)
	return function()
		local searched, _ =
				pcall(vim.cmd.normal, { args = { (vim.v.count > 0 and vim.v.count or "") .. key }, bang = true })
		if searched then
			pcall(vim.cmd.normal, "zzzv")
			vim.o.hlsearch = true
		end
	end
end

local function close_buf_or_win()
	local current_buffer = vim.api.nvim_win_get_buf(0)
	local current_window = vim.fn.win_getid()
	local window_list    = vim.api.nvim_list_wins()

	for _, window in pairs(window_list) do
		if vim.api.nvim_win_get_buf(window) == current_buffer and window ~= current_window then
			vim.print("window deleted")
			vim.cmd "close"
			return
		end
		vim.cmd "bd"
		return
	end
end

local function resize_horizontal(amount)
	local win = vim.api.nvim_get_current_win()
	local win_pos = vim.api.nvim_win_get_position(win)
	local win_width = vim.api.nvim_win_get_width(win)
	local total_width = vim.o.columns

	-- If the window's right edge reaches the total width, it's on the right side
	local is_right_side = (win_pos[2] + win_width) >= (total_width - 1)

	if is_right_side then
		amount = -amount
	end

	vim.cmd('vertical resize ' .. (win_width + amount))
end

---------------------------------------
-- #COMMANDS
---------------------------------------
vim.api.nvim_create_user_command("VTerm", function()
	vim.cmd("vsplit | terminal")
end, {})

vim.api.nvim_create_user_command("HTerm", function()
	vim.cmd("split | terminal")
end, {})

---------------------------------------
-- #KEYMAPS
---------------------------------------
vim.keymap.set("n", "<leader>q", function() vim.cmd("quit") end, { desc = "Quit Neovim" })
vim.keymap.set("n", "<leader>c", function() close_buf_or_win() end, { desc = "Close buffer" })
vim.keymap.set("n", "<leader>w", function() vim.cmd("write") end, { desc = "Save buffer" })
vim.keymap.set("n", "<leader>r", function() vim.cmd("write | restart") end, { desc = "Restart Neovim" })
vim.keymap.set("n", "<leader>t", ":terminal<cr>", { desc = "Open terminal" })
vim.keymap.set({ "n", "v" }, "g.", ":s/\\(\\S\\)\\zs\\(\\s\\+\\)/ /g<cr>",
	{ desc = "Remove extra spaces from line" })

vim.keymap.set("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
vim.keymap.set("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

vim.keymap.set("n", "n", better_search("n"), { desc = "Next search result centered", remap = true })
vim.keymap.set("n", "N", better_search("N"), { desc = "Previous search result centered", remap = true })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window", silent = false })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window", silent = false })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window", silent = false })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window", silent = false })

vim.keymap.set('n', '<A-Up>', '<cmd>resize +2<CR>')
vim.keymap.set('n', '<A-Down>', '<cmd>resize -2<CR>')
vim.keymap.set('n', '<A-Left>', function() resize_horizontal(-2) end)
vim.keymap.set('n', '<A-Right>', function() resize_horizontal(2) end)

-- Swap mark bindings
vim.keymap.set("n", "'", "`", {})
vim.keymap.set("n", "`", "'", {})

vim.keymap.set({ "n", "v" }, "s", "", { desc = "Text mods" })

vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })

vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = vim.g.border }) end)

---------------------------------------
-- #PLUGINS
---------------------------------------
-- Pack Autocmd, run scripts for plugins and other pack functions
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if kind == "update" then
			if name == "nvim-treesitter" then
				vim.cmd(":TSUpdate")
			end
		end
	end
})

-- Plugin host platforms
local GH = "https://github.com/"

-- Default plugin list.
vim.pack.add({
	GH .. "nvim-treesitter/nvim-treesitter",
	GH .. "Wansmer/treesj",
	GH .. "Wansmer/sibling-swap.nvim",
	GH .. "nvim-mini/mini.ai",


	GH .. "neovim/nvim-lspconfig",
	GH .. "folke/lazydev.nvim",
	{
		src = GH .. "Saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},

	GH .. "stevearc/conform.nvim",

	GH .. "AstroNvim/astrotheme",
	GH .. "nvim-mini/mini.icons",

	GH .. "folke/which-key.nvim",
	GH .. "NMAC427/guess-indent.nvim",

	GH .. "echasnovski/mini.files",
	GH .. "folke/snacks.nvim",
	GH .. "dtormoen/neural-open.nvim",
	GH .. "folke/flash.nvim",
	GH .. "serhez/bento.nvim",

	GH .. "nvim-mini/mini.surround",
	GH .. "windwp/nvim-autopairs",

	GH .. "eero-lehtinen/oklch-color-picker.nvim",

})

-- plugins stored in this section are to be used for lazy loading
-- or manually started with :packadd
-- vim.pack.add({
--
-- }, { load = function() end, })

---------------------------------------
-- @TREESITTER
---------------------------------------
local treesitter_ok, treesitter = pcall(require, "nvim-treesitter")
if treesitter_ok then
	treesitter.setup({
		ensure_installed = {
			"nushell",
			"odin",
			"rust",
			"python",
			"vim",
			"vimdoc",
			"toml",
			"json",
			"css",
			"html",
			"javascript"
		},
	})
	vim.o.foldtext = "v:lua.CustomFoldText()"

	function _G.CustomFoldText()
		local lnum = vim.v.foldstart
		local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]
		local indent = line:match("^%s*")
		local lines = vim.v.foldend - vim.v.foldstart + 1
		line = line:gsub("^%s*", "")

		return {
			{ indent .. "▶ ", "Folded" },
			{ line, "Normal" },
			{ "  ···  ", "Comment" },
			{ lines .. " lines", "LineNr" },
		}
	end

	vim.api.nvim_create_autocmd("FileType", {
		callback = function(args)
			if pcall(vim.treesitter.start, args.buf, args.match) then
				vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo[0][0].foldmethod = "expr"
				vim.wo[0][0].foldlevel = 99
				-- vim.treesitter.start(args.buf, args.match)
			end
		end,
	})

	treesitter.install({
		"odin",
		"nu",
		"rust",
		"c",
		"cpp",
		"python",
		"javascript",
		"json",
		"toml",
		"css",
		"html",
		"vim",
		"vimdoc"
	})
end

---------------------------------------
-- @TREESJ
---------------------------------------
local treesj_ok, treesj = pcall(require, "treesj")
if treesitter_ok and treesj_ok then
	treesj.setup({})
	vim.keymap.set("n", "sj", treesj.toggle, { desc = "Split / Join blocks" })
end

---------------------------------------
-- @SIBLINGSWAP
---------------------------------------
local sibling_swap_ok, sibling_swap = pcall(require, "sibling-swap")
if treesitter_ok and sibling_swap_ok then
	sibling_swap.setup({})
	vim.keymap.set("n", "sl", sibling_swap.swap_with_right, { desc = "Swap block right" })
	vim.keymap.set("n", "sh", sibling_swap.swap_with_left, { desc = "Swap block left" })
	vim.keymap.set("n", "sL", sibling_swap.swap_with_right_with_opp, { desc = "Swap block with opp right" })
	vim.keymap.set("n", "sH", sibling_swap.swap_with_left_with_opp, { desc = "Swap block with opp left" })
end

---------------------------------------
-- @MINI.AI
---------------------------------------
local miniai_ok, miniai = pcall(require, "mini.ai")
if treesitter_ok and miniai_ok then
	miniai.setup()
end

---------------------------------------
-- @LAZYDEV
---------------------------------------
local lazydev_ok, lazydev = pcall(require, "lazydev")
if lazydev_ok then
	lazydev.setup({
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			{ path = 'nvim-lspconfig',     words = { 'lspconfig' } }
		},
	})
end

---------------------------------------
-- @BLINK
---------------------------------------
local blink_ok, blink = pcall(require, "blink-cmp")
if blink_ok then
	blink.setup({
		keymap = {
			preset = "default",
			["<C-Space>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
			["<C-CR>"] = { "accept", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<Tab>"] = { "accept", "fallback" },
			["<DOWN>"] = { "select_next", "fallback" },
			["<UP>"] = { "select_prev", "fallback" },
			["<C-K>"] = { "select_prev", "fallback" },
			["<C-J>"] = { "select_next", "fallback" },
			["<C-D>"] = { "scroll_documentation_up", "fallback" },
			["<C-U>"] = { "scroll_documentation_down", "fallback" },
		},
		completion = {
			menu = {
				border = vim.g.border,
				winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
			},
			documentation = {
				window = {
					border = vim.g.border,
					winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
				},
			},
			ghost_text = {
				enabled = true,
			},
		},
		signature = {
			window = {
				border = vim.g.border,
				winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
			},
		},
	})
end

---------------------------------------
-- @CONFORM
---------------------------------------
local conform_ok, conform = pcall(require, "conform")
if conform_ok then
	conform.setup({
		default_format_opts = {
			lsp_format = "fallback",
		},
		formatters_by_ft = {
			python = { "ruff_format" },
		}

	})

	vim.api.nvim_create_autocmd("BufWrite", {
		pattern = "*",
		callback = function(args)
			conform.format({ bufnr = args.buf })
		end,
	})
else
	vim.api.nvim_create_autocmd("BufWrite", {
		pattern = "*",
		callback = function()
			vim.lsp.buf.format()
		end,
	})
end

---------------------------------------
-- @MINI.ICONS
---------------------------------------
local miniicons_ok, miniicons = pcall(require, "mini.icons")
if miniicons_ok then
	miniicons.setup()
end

---------------------------------------
-- @GUESS-INDENT
---------------------------------------
local guess_indent_ok, guess_indent = pcall(require, "guess-indent")
if guess_indent_ok then
	guess_indent.setup({})
end

---------------------------------------
-- @NVIM-AUTOPAIRS
---------------------------------------
local autopairs_ok, autopairs = pcall(require, "nvim-autopairs")
if autopairs_ok then
	autopairs.setup({})
end

---------------------------------------
-- @MINI.SURROUND
---------------------------------------
local minisurround_ok, minisurround = pcall(require, "mini.surround")
if minisurround_ok then
	minisurround.setup({
		mappings = {
			find = '',
			find_left = '',
			highlight = '',
			suffix_last = '',
			suffix_next = '',
		}
	})
end

---------------------------------------
-- @WHICH-KEY
---------------------------------------
local whichkey_ok, whichkey = pcall(require, "which-key")
if whichkey_ok then
	whichkey.setup({
		triggers = {
			{ "s",      mode = { "n", "v" } },
			{ "<auto>", mode = "nxso" },
		}
	})
end

---------------------------------------
-- @BENTO
---------------------------------------
local bento_ok, bento = pcall(require, "bento")
if bento_ok then
	bento.setup({
		-- main_keymap = "<tab>",
	})
end

---------------------------------------
-- @FLASH
---------------------------------------
-- BUG: the search is not stable and fails to jump.
local flash_ok, flash = pcall(require, "flash")
if flash_ok then
	flash.setup({
		modes = {
			char = {
				multi_line = false,
				jump_labels = true,
				jump = {
					autojump = true,
				},
			},
			search = {
				enabled = true,
			},
		},
	})
	vim.keymap.set("n", "<leader>s", flash.jump, { desc = "Flash jump" })
end

---------------------------------------
-- @SNACKS
---------------------------------------
local snacks_ok, snacks = pcall(require, "snacks")
if snacks_ok then
	snacks.setup({
		picker = { enabled = true },
		terminal = { enabled = true },
	})
	-- vim.keymap.set("n", "<C-p>", function() snacks.picker.files({}) end, { desc = "File picker" })
	vim.keymap.set("n", "<C-f>", function() snacks.picker.grep({}) end, { desc = "Search Words" })
	vim.keymap.set("n", "<leader>g", "", { desc = "Git", })
	vim.keymap.set("n", "<leader>gg", function() snacks.terminal.toggle("lazygit", {}) end,
		{ desc = "Open Lazy Git", remap = true })
end

---------------------------------------
-- @NEURAL-OPEN
---------------------------------------
local neuralopen_ok, neuralopen = pcall(require, "neural-open")
if neuralopen_ok then
	neuralopen.setup({
		file_sources = { "buffers", "files", "git_files" },
	})

	if snacks_ok then
		vim.keymap.set("n", "<C-p>", function()
			neuralopen.open({
				cwd = vim.fn.getcwd(),
			})
		end, { desc = "File picker", remap = true })
	end
end

---------------------------------------
-- @MINI.FILES
---------------------------------------
local minifiles_ok, minifiles = pcall(require, "mini.files")
if minifiles_ok then
	minifiles.setup({})
	vim.keymap.set("n", "<leader>e", function()
		if vim.bo.filetype == "minifiles" then
			minifiles.close()
		else
			minifiles.open()
		end
	end, { desc = "Open explorer" })

	vim.keymap.set("n", "<leader>o", function()
		local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
		if vim.bo.filetype == "minifiles" then
			minifiles.close()
		else
			minifiles.open(dir)
		end
	end, { desc = "Open explorer in buffer directory" })
end

---------------------------------------
-- @OKLCH-COLOR-PICKER
---------------------------------------
local oklch_ok, oklch = pcall(require, "oklch-color-picker")
if oklch_ok then
	oklch.setup({})
	vim.keymap.set("n", "<C-C>", ":ColorPickOklch<CR>", { desc = "Move to left window" })
end

---------------------------------------
-- @ASTROTHEME
---------------------------------------
local astrotheme_ok, astrotheme = pcall(require, "astrotheme")
if astrotheme_ok then
	astrotheme.setup({
		style = (function()
			if vim.g.kitty or vim.g.ghostty then
				return {
					transparent = true,
					inactive = false,
					neotree = false,
					-- popup = false,
					float = true,
					border = false,
					title_invert = true,
				}
			end
			return {
				border = false,
				inactive = false,
				title_invert = true,
			}
		end)(),

		palettes = {
			global = {},
		},

		highlights = {
			global = {
				modify_hl_groups = function(hl, c)
					hl.Title.italic = true
					hl.FloatTitle.italic = true

					hl.NormalFloat.blend = vim.o.winblend
					hl.FloatBorder.blend = vim.o.winblend
					hl.FloatTitle.blend = vim.o.winblend

					hl.PmenuSel = { fg = c.ui.base, bg = c.ui.accent, bold = true, blend = 0 }
				end,
			},
		},
	})
	vim.cmd("colorscheme astrodark")
end

---------------------------------------
--- #LSP
---------------------------------------

vim.lsp.config("nushell", {
	cmd = { "nu", "--lsp", "--no-config-file" },
	filetypes = { "nu" },
	root_markers = { { "config.nu", "env.nu" }, ".git" },
	single_file_support = true,
})

vim.lsp.enable({ "lua_ls", "nushell", "ols", "hyprls", "ty", "ruff" })
