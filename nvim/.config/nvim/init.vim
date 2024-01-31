"""
" Plugins
"""
call plug#begin(stdpath('config') . '/plug')
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'github/copilot.vim', { 'branch': 'release' }
  Plug 'itchyny/lightline.vim'
  Plug 'junegunn/fzf.vim'
  Plug 'mfussenegger/nvim-lint'
  Plug 'neovim/nvim-lspconfig'
  Plug 'sheerun/vim-polyglot'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-rhubarb'
  Plug 'tpope/vim-surround'
call plug#end()

"""
" Options
"""
set runtimepath+=$HOMEBREW_PREFIX/opt/fzf
let &packpath = &runtimepath
let mapleader = " "

set background=light
hi link Whitespace ColorColumn

set clipboard+=unnamedplus
set colorcolumn=120
set expandtab
set linebreak
set list
set noshowmode
set number
set path=.
set relativenumber
set scrolloff=7
set shiftwidth=2
set smartindent
set splitbelow
set splitright
set tabstop=2
set undofile

set textwidth=100
set nowrap

"""
" Autocmds
"""

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message (it's
" likely a different one than last time).
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | end

augroup reload_vimrc
  autocmd!
  autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
augroup end

"""
" Maps
"""
nmap <leader>vimrc :tabe $MYVIMRC<CR>
nmap <leader>yf :let @+ = expand("%:t:r")<CR>
nmap <leader>yp :let @+ = expand("%")<CR>

" Convert text to sentence case
nnoremap <leader>gu :s/\<\(\w\)\(\w*\)\>/\u\1\L\2/g<CR> <bar> :noh<CR>
vnoremap <leader>gu :s/\<\(\w\)\(\w*\)\>/\u\1\L\2/g<CR> <bar> :noh<CR>

"""
" Plugin Config
"""

" Fzf
autocmd VimEnter * map <C-p> :Files<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <Leader>a :Rg<Space>
nnoremap <Leader>A :Rg<C-R><C-W><CR>

" Lightline
let g:lightline = {
  \'colorscheme': 'wombat',
\ }

" Lua
if ! empty(globpath(&rtp, 'plug/*'))
  lua require('init')
endif
