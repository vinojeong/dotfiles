vim.opt.clipboard = "unnamedplus"
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.smartcase = true
vim.opt.scrolloff = 5
vim.opt.showmatch = true
vim.opt.mat = 1
vim.keymap.set('n', 'j', 'gj', { noremap = true, silent = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true, silent = true })

-- vim.cmd 'colorscheme wildcharm'
-- slate, quiet, ron, shine
-- vim.cmd 'colorscheme wildcharm'

-- vim.o.termguicolors = true
-- some themes I downloaded:
-- gruvbox, tender, apprentice, wombat256mod, spacecamp, termschool, orbital, fahrenheit, github, deus, happy-hacking, nord, dogrun, ansi, seoul256, challenger_deep, lettuce

-- check for theme, if it doesn't exist, use a built-in theme
local ok, _ = pcall(vim.cmd, "colorscheme challenger_deep")
if not ok then
  vim.cmd("colorscheme wildcharm")
end

-- override
vim.cmd("colorscheme termschool")

-- statusline

vim.opt.statusline = "%!v:lua.MyStatusline()"

function MyStatusline()
	-- local mode = vim.fn.mode()

	-- path
	local file_path = vim.fn.expand("%:p")
	if file_path == "" then file_path = "[unknown]" end

	-- line:col
  	local line_col = string.format("(%d, %d)", vim.fn.line("."), vim.fn.col("."))

	-- progress percentage
  	local current = vim.fn.line(".")
	local total = vim.fn.line("$")
	local percent = math.floor((current / total) * 100)
	local progress = string.format("%3d%%%%", percent)

  	-- highlight groups
	local hl_mode = "StatusLineMode"
  	local hl_filename = "StatusLineFilename"
  	local hl_info = "StatusLineInfo"

	local fileformat = vim.bo.fileformat  -- unix, dos, mac
	local encoding = vim.o.fileencoding ~= '' and vim.o.fileencoding or vim.o.encoding
	local filesize = vim.fn.getfsize(vim.fn.expand("%:p"))
	if filesize < 0 then
		filesize = ""
	else
		if filesize < 1024 then
			filesize = string.format("%d B", filesize)
		elseif filesize < 1024 * 1024 then
			filesize = string.format("%.1f KB", filesize / 1024)
		else
			filesize = string.format("%.1f MB", filesize / (1024 * 1024))
		end
	end

	return string.format(
		"%%#%s# %s %s | %s | %s | %s %%=" .. "%%#%s# %s ",
		hl_path,
		file_path,
		line_col,
		fileformat,
		encoding,
		filesize,
		hl_info,
		progress
	)
end
