"""
" Plugins
"""
call plug#begin(stdpath('config') . '/plug')
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'itchyny/lightline.vim'
  Plug 'junegunn/fzf.vim'
  Plug 'neomake/neomake'
  Plug 'sheerun/vim-polyglot'
  Plug 'Townk/vim-autoclose'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-dadbod'
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

augroup fix_whitespace
  autocmd FileType ruby autocmd BufWritePre <buffer> %s/\s\+$//e
augroup end

"""
" Functions
"""
function! Interview(type)
  let date = strftime("%Y_%m_%d")
  let year = strftime("%Y")
  exe 'new ' . year . '/' . date . '_' . a:type . '.md'
endfun

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

nmap <leader>nf :call Interview("nf")<CR>
nmap <leader>ts :call Interview("ts")<CR>

" Convert text to sentence case
nnoremap <leader>gu :s/\<\(\w\)\(\w*\)\>/\u\1\L\2/g<CR> <bar> :noh<CR>
vnoremap <leader>gu :s/\<\(\w\)\(\w*\)\>/\u\1\L\2/g<CR> <bar> :noh<CR>

"""
" Plugin Config
"""

" Dadbod
function! Time(cmd) range
  let starttime = reltime()
  execute a:firstline . "," . a:lastline . a:cmd
  let endtime = str2float(reltimestr(reltime(starttime)))
  redraw!
  echohl MoreMsg
  echo printf("%.02g sec", endtime)
  echohl None
endfun

augroup db_setup
  autocmd bufread attention.sql let b:db = $ATTENTION_DB
  autocmd bufread bibliography.sql let b:db = $BIBLIOGRAPHY_DB
  autocmd bufread contacts.sql let b:db = $CONTACTS_DB
  autocmd bufread email.sql let b:db = $EMAIL_DB
  autocmd bufread main.sql let b:db = $MAIN_DB
  autocmd bufread mentions.sql let b:db = $MENTIONS_DB
  autocmd bufread new_notifications.sql let b:db = $NEW_NOTIFICATIONS_DB
  autocmd bufread notifications.sql let b:db = $NOTIFICATIONS_DB
  autocmd bufread ring.sql let b:db = $RING_DB
  autocmd bufread distribution_system.sql let b:db = $DIST_SYSTEM_DB
  autocmd bufread redshift.sql let b:db = $REDSHIFT
  autocmd bufread redshift_writable.sql let b:db = $REDSHIFT_WRITABLE
  autocmd bufread qa.sql let b:db = $QA_DB
  autocmd bufread qa_attention.sql let b:db = $QA_ATTENTION_DB
  autocmd bufread qa_new_notifications.sql let b:db = $QA_NEW_NOTIFICATIONS_DB
  autocmd bufread qa_ring.sql let b:db = $QA_RING_DB
  autocmd bufread qa_redshift.sql let b:db = $QA_REDSHIFT
  autocmd bufread dev.sql let b:db = $DEV_DB
  autocmd bufread dev_attention.sql let b:db = $DEV_ATTENTION_DB
  autocmd bufread dev_email.sql let b:db = $DEV_EMAIL_DB
  autocmd bufread dev_mentions.sql let b:db = $DEV_MENTIONS_DB
  autocmd bufread dev_payments.sql let b:db = $DEV_PAYMENTS_DB
  autocmd bufread dev_ring.sql let b:db = $DEV_RING_DB
  autocmd bufread dev_redshift.sql let b:db = $DEV_REDSHIFT
  autocmd bufread test_notifications.sql let b:db = $TEST_NOTIFICATIONS_DB
augroup end

nmap Q :call Time(".DB")<CR>
vmap Q :call Time("DB")<CR>

" Fzf
autocmd VimEnter * map <C-p> :Files<CR>
map <C-M-p> :Buffers<CR>

" Lightline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

" Neomake
let g:neomake_javascript_enabled_makers = ['yarn']
let g:neomake_yarn_maker = {
      \ 'args': [
      \   'lint',
      \   '--format', 'compact'
      \ ],
      \ 'errorformat': '%E%f: line %l\, col %c\, Error - %m,' .
      \   '%W%f: line %l\, col %c\, Warning - %m, %-G, %-G%*\d problems%#',
      \ 'output_stream': 'stdout',
      \ }
call neomake#configure#automake('w')

" Vimwiki
let vimwiki_default = {
  \'path': '~/Documents/notes', 'syntax': 'markdown', 'ext': '.md', 'links_space_char': '_'
\}
let g:vimwiki_list = [vimwiki_default]
let g:vimwiki_markdown_header_style = 0
let g:vimwiki_auto_header = 1

"""
" Language-specific
"""

" Markdown
let g:vim_markdown_new_list_item_indent = 0
