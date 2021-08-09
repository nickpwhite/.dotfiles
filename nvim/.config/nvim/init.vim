"""
" Plugins
"""
call plug#begin(stdpath('config') . '/plug')
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'dense-analysis/ale'
  Plug 'itchyny/lightline.vim'
  Plug 'junegunn/fzf.vim'
  Plug 'sheerun/vim-polyglot'
  Plug 'Townk/vim-autoclose'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-rhubarb'
  Plug 'tpope/vim-surround'
  Plug 'vimwiki/vimwiki'
call plug#end()

"""
" Options
"""
set runtimepath+=/usr/local/Cellar/fzf/0.27.0
let &packpath = &runtimepath
let mapleader = " "

set background=dark
hi link Whitespace ColorColumn

set clipboard+=unnamedplus
set colorcolumn=100
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

augroup templates
  autocmd BufNewFile *.rb 0r ~/.config/nvim/templates/skeleton.rb
  autocmd BufNewFile *_nf.md 0r ~/.config/nvim/templates/nf_skeleton.md
  autocmd BufNewFile *_ts.md 0r ~/.config/nvim/templates/ts_skeleton.md
  autocmd BufNewFile *.md exe 'g/%date%/s//'.strftime("%Y-%m-%d").'/'
augroup end

augroup reload_vimrc
  autocmd!
  autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
augroup end

"""
" Maps
"""
nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk

nmap <leader>lo :lopen<CR>
nmap <leader>lc :lclose<CR>

nmap <leader>vimrc :tabe $MYVIMRC<CR>
nmap <leader>yf :let @+ = expand("%:t:r")<CR>
nmap <leader>yp :let @+ = expand("%")<CR>

" Convert text to sentence case
nnoremap <leader>gu :s/\<\(\w\)\(\w*\)\>/\u\1\L\2/g<CR> <bar> :noh<CR>
vnoremap <leader>gu :s/\<\(\w\)\(\w*\)\>/\u\1\L\2/g<CR> <bar> :noh<CR>

"""
" Plugin Config
"""

" ALE
call ale#linter#Define('ruby', {
  \   'name': 'sorbet-payserver',
  \   'lsp': 'stdio',
  \   'executable': 'true',
  \   'command': 'pay exec scripts/bin/typecheck --lsp',
  \   'language': 'ruby',
  \   'project_root': $HOME . '/stripe/pay-server',
\})

if !exists("g:ale_linters")
  let g:ale_linters = {}
endif

if fnamemodify(getcwd(), ':p') =~ $HOME.'/stripe/pay-server'
  let g:ale_linters['ruby'] = ['sorbet-payserver', 'rubocop']
  let g:ale_linters['javascript'] = ['eslint', 'flow-language-server']
endif

let g:ale_pattern_options_enabled = 1
let g:ale_pattern_options = {
  \ 'pay-server/.*\.rb$': { 'ale_ruby_rubocop_executable': 'scripts/bin/rubocop-daemon/rubocop' },
  \ 'pay-server/docs/content/.*\.md$':
  \ {
  \   'ale_linters': ['vale'],
  \   'ale_markdown_vale_options': '--config ' . $HOME . '/stripe/pay-server/docs/vale/vale.ini',
  \   'ale_markdown_vale_input_file': '%s',
  \ }
\}

let g:ale_fixers = {
  \ 'javascript': ['eslint'],
  \ 'ruby': ['rubocop', 'sorbet'],
\}

let g:ale_fix_on_save = 1

nnoremap <C-]> :ALEGoToDefinition<CR>

nmap Q :call Time(".DB")<CR>
vmap Q :call Time("DB")<CR>

" Fzf
function! ToplevelFiles()
  let dir = systemlist('git rev-parse --show-toplevel')[0]

  exe "Files " . dir
endfun

autocmd VimEnter * map <C-p> :Files<CR>
nnoremap <C-M-p> :call ToplevelFiles()<CR>
nnoremap <C-b> :Buffers<CR>
nnoremap <Leader>a :Rg<Space>
nnoremap <Leader>A :Rg<C-R><C-W><CR>

" Lightline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

" Vimwiki
let vimwiki_default = {
  \'path': '~/Documents/notes', 'syntax': 'markdown', 'ext': '.md', 'links_space_char': '_'
\}
let g:vimwiki_list = [vimwiki_default]
let g:vimwiki_markdown_header_style = 0
let g:vimwiki_auto_header = 1

nnoremap <Leader>t :VimwikiToggleListItem<CR>
vnoremap <Leader>t :VimwikiToggleListItem<CR>

"""
" Language-specific
"""

" Markdown
let g:vim_markdown_new_list_item_indent = 0
