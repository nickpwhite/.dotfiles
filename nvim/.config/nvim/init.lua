-- Plugins
local Plug = vim.fn["plug#"]
vim.call("plug#begin")
Plug("christoomey/vim-tmux-navigator")
Plug("github/copilot.vim")
Plug("mfussenegger/nvim-lint")
Plug("neovim/nvim-lspconfig")
Plug("nvim-lua/plenary.nvim")
Plug("nvim-lualine/lualine.nvim")
Plug("nvim-telescope/telescope.nvim", { tag = "0.1.8" })
Plug("nvim-telescope/telescope-fzf-native.nvim", {
  ["do"] = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
})
Plug("nickpwhite/vim-polyglot")
Plug("stevearc/conform.nvim")
Plug("tpope/vim-commentary")
Plug("tpope/vim-fugitive")
Plug("tpope/vim-rails")
Plug("tpope/vim-repeat")
Plug("tpope/vim-rhubarb")
Plug("tpope/vim-surround")
vim.call("plug#end")

-- Options
vim.g.mapleader = " "

vim.cmd.colorscheme("retrobox")

local system_theme =
  vim.system({ "defaults", "read", "-g", "AppleInterfaceStyle" }):wait().stdout:gsub("%s+", "")

if system_theme == "Dark" then
  vim.opt.background = "dark"
else
  vim.opt.background = "light"
end
vim.cmd.highlight({ "link", "Whitespace", "ColorColumn" })

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

vim.opt.textwidth = 100
vim.opt.wrap = false

-- Autocmds
local autocmds = vim.api.nvim_create_augroup("init.lua", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Open file to last location",
  command = 'silent! normal! g`"zv',
  group = autocmds,
})
vim.api.nvim_create_autocmd("BufWritePost", {
  desc = "Reload init.lua",
  pattern = { vim.env.MYVIMRC },
  command = "luafile $MYVIMRC",
  group = autocmds,
})

-- Mappings
vim.keymap.set(
  "n",
  "<Leader>vimrc",
  "<cmd>tabe $MYVIMRC<cr>",
  { desc = "Open init.lua in a new tab" }
)
vim.keymap.set(
  "n",
  "<Leader>yf",
  '<cmd>let @+ = expand("%:t:r")<cr>',
  { desc = "Yank the current filename to the clipboard" }
)
vim.keymap.set(
  "n",
  "<Leader>yp",
  '<cmd>let @+ = expand("%")<cr>',
  { desc = "Yank the current path to the clipboard" }
)

-- Plugin Config
-- conform.nvim
require("conform").setup({
  formatters = {
    stylua = {
      prepend_args = { "--config-path", vim.env.HOME .. "/.config/nvim/stylua.toml" },
    },
  },
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { lsp_format = "fallback" }
  end,
})

-- telescope.nvim
require("telescope").setup()
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<C-b>", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
vim.keymap.set("n", "<C-f>", "<cmd>Telescope live_grep<cr>", { desc = "Grep the codebase" })

-- lualine.nvim
require("lualine").setup({
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "encoding", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

-- nvim-lspconfig
require("nvim-lspconfig")
