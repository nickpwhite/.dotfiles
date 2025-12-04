vim.g.mapleader = " "
vim.opt.clipboard:append("unnamedplus")
vim.opt.colorcolumn = "100"
vim.opt.expandtab = true
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.matchpairs:append("<:>")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 7
vim.opt.shiftwidth = 2
vim.opt.showmode = false
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.undofile = true

vim.opt.wrap = false

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<C-h>", "<Cmd>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>", opts)
vim.keymap.set("n", "<C-j>", "<Cmd>call VSCodeNotify('workbench.action.focusBelowGroup')<CR>", opts)
vim.keymap.set("n", "<C-k>", "<Cmd>call VSCodeNotify('workbench.action.focusAboveGroup')<CR>", opts)
vim.keymap.set("n", "<C-l>", "<Cmd>call VSCodeNotify('workbench.action.focusRightGroup')<CR>", opts)

vim.keymap.set("n", "]d", "<Cmd>call VSCodeNotify('editor.action.marker.next')<CR>", opts)
vim.keymap.set("n", "[d", "<Cmd>call VSCodeNotify('editor.action.marker.prev')<CR>", opts)

vim.keymap.set("n", "<Leader>gd", "<Cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>", opts)
vim.keymap.set("n", "<Leader>gr", "<Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>", opts)
vim.keymap.set("n", "<Leader>rn", "<Cmd>call VSCodeNotify('editor.action.rename')<CR>", opts)
