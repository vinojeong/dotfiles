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

vim.o.termguicolors = true

-- check for theme, if it doesn't exist, use a built-in theme
local ok, _ = pcall(vim.cmd, "colorscheme challenger_deep")
if not ok then
  vim.cmd("colorscheme sorbet")
end

-- override
-- vim.cmd("colorscheme jellybeans")

-- return to last edit position
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local ft = vim.bo.filetype
	-- exclude commit messages
    if ft == "gitcommit" then return end

    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)

    if mark[1] > 1 and mark[1] <= lcount then
      vim.cmd('normal! g`"')
    end
  end,
})

-- statusline

vim.opt.statusline = "%!v:lua.statusline()"

function statusline()
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

	local fileformat = vim.bo.fileformat  -- unix/dos/mac
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
