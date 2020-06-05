"""
" Plugins
"""
call plug#begin(stdpath('config') . '/plug')
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'dbeniamine/todo.txt-vim'
  Plug 'itchyny/lightline.vim'
  Plug 'junegunn/fzf.vim'
  Plug 'neomake/neomake'
  Plug 'scrooloose/nerdcommenter'
  Plug 'sheerun/vim-polyglot'
  Plug 'Townk/vim-autoclose'
  Plug 'tpope/vim-dadbod'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
call plug#end()

"""
" Options
"""
set runtimepath+=~/src/fzf
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
  autocmd FileType ruby,sql autocmd BufWritePre <buffer> %s/\s\+$//e
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
nmap <leader>yf :let @+ = expand("%")<CR>

nmap <leader>nf :call Interview("nf")<CR>
nmap <leader>ts :call Interview("ts")<CR>

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
      \ 'colorscheme': 'seoul256',
      \ }

function! LightlineModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! LightlineFilename()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? g:lightline.fname :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
  let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

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

"""
" Language-specific
"""

" Markdown
let g:vim_markdown_new_list_item_indent = 0

" Todo
au filetype todo imap <buffer> + +<C-X><C-O>
au filetype todo imap <buffer> @ @<C-X><C-O>
au filetype todo setlocal completeopt-=preview
au filetype todo setlocal completeopt+=menuone
au filetype todo setlocal omnifunc=todo#Complete
au BufReadPost todo.txt !drive pull todo.txt
au BufWritePost todo.txt !drive push todo.txt
let g:Todo_txt_prefix_creation_date=1
