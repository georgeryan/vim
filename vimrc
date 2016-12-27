" Requires Vundle:
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

" don't emulate vi
set nocompatible

filetype off
set rtp+=~/.vim/bundle/Vundle.vim"

call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'junegunn/vim-easy-align'
Plugin 'scrooloose/nerdtree'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'scrooloose/nerdcommenter'
call vundle#end()
filetype plugin indent on

set background=dark

set cursorline
highlight CursorLine cterm=none ctermbg=236

" keep backups of files
set backup

" set command line history
set history=50

" always show the status line
set ls=2

" always have at least two lines of context around 
" the cursor when editing
set scrolloff=2

" allow vim to hide buffers instead of forcing them
" to be written to disk when switched. this lets tabs
" work nicely
set hidden

" enable extended % matching
runtime macros/matchit.vim

" allow for more options in command mode tab completion
set wildmode=list:longest
set wildmenu

set softtabstop=2 " treat spaces like tabs when backspacing

set showmode
set showcmd
set shiftwidth=2

" use current line's indent to predict new line's indenting
set autoindent

" guess the indent level of any new line based on the previous
set smartindent

" set 2-space indents and no tabs. tabs are evil
set tabstop=2
set shiftwidth=2
set expandtab

let loaded_matchparen = 1

" ignore case while searching
set ignorecase
set smartcase

" display best-match-so-far while searching
set incsearch

" move between tabs easily.
map <M-left> :tabprevious<CR>
map <M-right> :tabnext<CR>

" set the wildmode to show a list of matching files instead
" of the standard, crazy behaviour.
set wildmode=longest,list

" keep cursor on the same column while moving up and down.
set nostartofline

" set up ctrl-n word completion
set completeopt=menuone,longest,preview

" customize the status line
set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V

set nowritebackup 
set nobackup

syntax on

"au FileType make setlocal noexpandtab
"au FileType make setlocal set list listchars=tab:»·,trail:·

" Change the directory to the one that the currently active
" buffer is in.
autocmd BufEnter * lcd %:p:h

" Persistent undo
call system('mkdir $HOME/.vim/undos' ) 
set undolevels=1000
set undodir=$HOME/.vim/undos 
set undofile

" Copy + Paste (enables the use of ctrl-v, c and x to paste, copy and cut)
nnoremap <silent> <sid>Paste :call <sid>Paste()<cr>
vnoremap <c-x> "+x
vnoremap <c-c> "+y
map <c-v> "+gP
cmap <c-v> <c-r>+
func! <sid>Paste()
    let ove = &ve
    set ve=all
    normal `^
    if @+ != ''
        normal "+gP
    endif
    let c = col(".")
    normal i
    if col(".") < c
        normal l
    endif
    let &ve = ove
endfunc
inoremap <script> <c-v> x<bs><esc><sid>Pastegi
vnoremap <script> <c-v> "-c<esc><sid>Paste

" Toggle spell-checking on and off with ',s'
"let mapleader = ","
"nmap <silent> <leader>s :set spell!<CR>

" Set spell-checking region to Canadian English
set spelllang=en_ca

:autocmd BufRead,BufNewFile *.cmake,CMakeLists.txt,*.cmake.in runtime! indent/cmake.vim 
:autocmd BufRead,BufNewFile *.cmake,CMakeLists.txt,*.cmake.in setf cmake
:autocmd BufRead,BufNewFile *.ctest,*.ctest.in setf cmake

set nohlsearch

let g:ctrlp_root_markers = ['maddox']
let g:ctrlp_working_path_mode = 'rc'
let g:ctrlp_custom_ignore = { 'dir': '\v[\/](b|cb)$' }

set tags=./tags;/

nmap <silent> <C-a>t :NERDTreeToggle<CR>
nmap <silent> <C-a>n :TagbarToggle<CR>

let g:makeshift_ignored=['Jamfile', 'SConstruct', 'Rakefile', 'build.gradle', 'build.xml', 'pom.xml'   ]

"
" The following makes the uncrustify command work well.
" Restore the cursor position, window positin, and last search after runnin
" a command.
"
function! Preserve(command)

  " Save the last search
  let search = @/

  " Save the current cursor position
  let cursor_position = getpos('.')

  " Save the current window position
  normal! H
  let window_position = getpos('.')
  call setpos('.', cursor_position )

  " Execute the command
  execute a:command

  " Restore the last search
  let @/ = search

  " Restore the previous window position
  call setpos('.', window_position )
  normal! zt

  " Restore the previous cursor position
  call setpos('.', cursor_position )
endfunction

"
" Map uncrustify to a key in normal mode
"
function! Uncrustify()
  call Preserve(':silent %!uncrustify -q ')
endfunction

nmap <silent> <leader>u :call Uncrustify()<CR>
nmap <silent> <leader>d :TagbarToggle<CR>
nmap <silent> <leader>a :NERDTreeToggle<CR>

"autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

let g:ctrlp_prompt_mappings = {
  \ 'PrtSelectMove("j")':   ['<c-j>', '<c-n>'],
  \ 'PrtSelectMove("k")':   ['<c-k>', '<c-p>'],
  \ 'PrtHistory(-1)':       ['<down>'],
  \ 'PrtHistory(1)':        ['<up>'],
  \ }

" Restore cursor position, window position, and last search after running a
" command.
function! Preserve(command)
  " Save the last search.
  let search = @/

  " Save the current cursor position.
  let cursor_position = getpos('.')

  " Save the current window position.
  normal! H
  let window_position = getpos('.')
  call setpos('.', cursor_position)

  " Execute the command.
  execute a:command

  " Restore the last search.
  let @/ = search

  " Restore the previous window position.
  call setpos('.', window_position)
  normal! zt

  " Restore the previous cursor position.
  call setpos('.', cursor_position)
  endfunction

  " Specify path to your Uncrustify configuration file.
  let g:uncrustify_cfg_file_path =
  \ shellescape(fnamemodify('~/.uncrustify.cfg', ':p'))

function! Uncrustify(language)
  call Preserve(':silent %!uncrustify'
      \ . ' -q '
      \ . ' -l ' . a:language
      \ . ' -c ' . g:uncrustify_cfg_file_path)
endfunction

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

set csto=1

function! LoadCScope()
  let db =findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  endif
endfunction

au BufEnter /* call LoadCScope()

