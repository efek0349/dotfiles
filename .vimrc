call plug#begin('~/.vim/plugged')

Plug 'jiangmiao/auto-pairs'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'sjl/gundo.vim'
Plug 'godlygeek/tabular'
Plug 'scrooloose/nerdtree'
Plug 'humiaozuzu/TabBar'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-fugitive'
Plug 'Lokaltog/vim-powerline'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-sleuth'
Plug 'preservim/vim-markdown'
Plug 'altercation/vim-colors-solarized'
Plug 'dense-analysis/ale'
Plug 'vim-scripts/c.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files

call plug#end()

" ALE yapılandırması
let g:ale_linters = {
\   'c': ['gcc', 'clang'],
\}

" Auto-pairs ayarları
let g:auto_pairs = 1

let g:coc_global_extensions = ['coc-clangd']

"uninstall command :CocUninstall coc-tabnine
let g:coc_source_disable = {'tabnine': 1}

"Disable tags file
let g:gutentags_ctags_executable = 'ectags'
let g:gutentags_generate_on_new = 0
let g:gutentags_generate_on_missing = 0
let g:gutentags_generate_on_write = 0
let g:gutentags_generate_on_empty_buffer = 0
"let g:gutentags_ctags_extra_args = ['--ignore-unsupported-options']

set tags=

set hlsearch
syntax on
filetype plugin indent on

let g:is_unix=1
"Set shell to be ksh
set shell=ksh

" encoding dectection
set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1

" enable filetype dectection and ft specific plugin/indent
filetype plugin indent on

" enable syntax hightlight and completion
syntax on

"--------
" Vim UI
"--------
" color scheme
set background=dark
"color solarized
let g:hybrid_use_Xresources = 1
colorscheme hybrid
" highlight current line
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn

set colorcolumn=80
highlight ColorColumn ctermbg=red guibg=red
"set cursorline cursorcolumn

" Toggle fold
nnoremap <space> za

" Folding
set foldignore=           " don't ignore anything when folding
set foldlevelstart=99     " no folds closed on open
set foldmethod=marker     " collapse code using markers
set foldnestmax=1         " limit max folds for indent and syntax methods

" Folding rules
autocmd FileType c,cpp setlocal foldmethod=syntax foldnestmax=5

" editor settings
set viminfo=
set history=0
set nocompatible
"set nofoldenable                                                  " disable folding"
set confirm                                                       " prompt when existing from an unsaved file
set backspace=indent,eol,start                                    " More powerful backspacing
set t_Co=256                                                      " Explicitly tell vim that the terminal has 256 colors "
set mouse=a                                                       " use mouse in all modes
set report=0                                                      " always report number of lines changed                "
set nowrap                                                        " dont wrap lines
set scrolloff=5                                                   " 5 lines above/below cursor when scrolling
set number                                                        " show line numbers
set showmatch                                                     " show matching bracket (briefly jump)
set showcmd                                                       " show typed command in status bar
set title                                                         " show file in titlebar
set laststatus=2                                                  " use 2 lines for the status bar
set matchtime=2                                                   " show matching bracket for 0.2 seconds
set matchpairs+=<:>                                               " specially for html
"set relativenumber

" Default Indentation
set autoindent
set smartindent     " indent when
set tabstop=4       " tab width
set softtabstop=4   " backspace
set shiftwidth=4    " indent width
set textwidth=78
" set smarttab
set expandtab       " expand tab to space

autocmd FileType php setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
autocmd FileType ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120
autocmd FileType coffee,javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120
autocmd FileType html,htmldjango,xhtml,haml setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=0
autocmd FileType sass,scss,css setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
" For all text files set 'textwidth' to 80 characters.
autocmd FileType text setlocal textwidth=80

" tabbar
let g:Tb_MaxSize = 2
let g:Tb_TabWrap = 1

" easy-motion
let g:EasyMotion_leader_key = '<Leader>'

" Tagbar
let g:tagbar_left=1
let g:tagbar_width=30
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0
let g:tagbar_compact = 1
" tag for coffee
if executable('coffeetags')
  let g:tagbar_type_coffee = {
        \ 'ctagsbin' : 'coffeetags',
        \ 'ctagsargs' : '',
        \ 'kinds' : [
        \ 'f:functions',
        \ 'o:object',
        \ ],
        \ 'sro' : ".",
        \ 'kind2scope' : {
        \ 'f' : 'object',
        \ 'o' : 'object',
        \ }
        \ }

  let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'sort' : 0,
    \ 'kinds' : [
        \ 'h:sections'
    \ ]
    \ }
endif

" Nerd Tree
let NERDChristmasTree=0
let NERDTreeWinSize=30
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\~$', '\.pyc$', '\.swp$']
" let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\~$']
let NERDTreeShowBookmarks=1
let NERDTreeWinPos = "right"

" ctrlp
set wildignore+=*/tmp/*,*.so,*.o,*.a,*.obj,*.swp,*.zip,*.pyc,*.pyo,*.class,.DS_Store  " MacOSX/Linux
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'

" Keybindings for plugin toggle
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
nmap <F5> :TagbarToggle<cr>
nmap <F6> :NERDTreeToggle<cr>
nnoremap <leader>v V`]

"------------------
" Useful Functions
"------------------
" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" When editing a file, always jump to the last cursor position
autocmd BufReadPost *
      \ if ! exists("g:leave_my_cursor_position_alone") |
      \     if line("'\"") > 0 && line ("'\"") <= line("$") |
      \         exe "normal g'\"" |
      \     endif |
      \ endif

" w!! to sudo & write a file
cmap w!! %!sudo tee >/dev/null %

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" eggcache vim
nnoremap ; :
:command W w
:command WQ wq
:command Wq wq
:command Q q
:command Qa qa
:command QA qa

" for macvim
if has("gui_running")
    set go=aAce  " remove toolbar
    set guicursor=a:block-blinkon0
    "set transparency=30
"    set guifont=Fira\ Sans:h14
	set guifont=Inconsolata\ 12
    set showtabline=2
    set columns=140
    set lines=40
endif

" => .sh, SetTitle
autocmd BufNewFile *.sh exec ":call SetTitle()"
"
func SetTitle()
    if &filetype == 'sh'
        call setline(1, "#!/bin/sh")
        call append(line(".")+0, "#########################################################################")
        call append(line(".")+1, "#   Author: efek0349, (https://github.com/efek0349)")
        call append(line(".")+2, "#   E-mail: kndmrefe[at]gmail[dot]com")
        call append(line(".")+3, "#  Created: ".strftime("%F  T %H:%M"))
        call append(line(".")+4, "# Revision: none")
        call append(line(".")+5, "# FileName: ".expand("%"))
        call append(line(".")+6, "#########################################################################")
        call append(line(".")+7, "")
    endif
endfunc

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.

" Temporarily disable syntax highlighting for pasting from the clipboard, then re-enable it
function! PasteWithSyntaxOff()
    " Disable syntax highlighting
    syntax off
    " Paste the clipboard content
    normal! "+p
    " Re-enable syntax highlighting
    syntax on
endfunction

" Map the above function to a key combination
" For example, bind this function to <Leader>p
nnoremap <Leader>p :call PasteWithSyntaxOff()<CR>

function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d ff=%s ft=%s %set :",
	\&tabstop, &shiftwidth, &textwidth, &fileformat, &filetype, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

