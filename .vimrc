" TODO: http://nvie.com/posts/how-i-boosted-my-vim/

" Removing pathogen
"execute pathogen#infect()

" install vimplug if not present
" TODO: this path should actually be ~/.config/nvim/autoload/plug.vim?
"if empty(glob('~/.vim/autoload/plug.vim'))
"  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
"    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
"endif

" Replacing with vim-plug
call plug#begin('~/projects/vim')

" I trust tpope, I guess
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-repeat'

" TabNine
Plug 'terabyte/tabnine-vim'

" fzf integration - currently some things are broken inside tmux because...reasons: https://github.com/junegunn/fzf.vim/issues/400
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" but these other ones, I'm gonna fork and read before running
Plug 'terabyte/vim-flake8'
Plug 'terabyte/taglist.vim'
Plug 'terabyte/vim-highlightedyank'


" First time, run :PlugInstall to install these
" Future times after edit, run :PlugUpdate
"
" examples:
" Plug 'https://github.com/blah/foo.git' " <== any git url is allowed
"
" on demand loading:
" Plug 'foo/bar' { 'on': 'SomeToggle' }
" Plug 'foo/bar' { 'for': 'somefiletype' }
"
" plugin options:
" Plug 'blah/foo', { 'tag': '2.*' }
" Plug 'blah/foo', { 'branch': 'stable' }
" more here: https://github.com/terabyte/vim-plug
"

" TODO: plugins I should try:
" https://github.com/terryma/vim-multiple-cursors
" https://github.com/easymotion/vim-easymotion
" ALE (syntastic replacement)
" auto-pairs, gundo, camelcasemotion, comment
"
call plug#end()


set nocompatible
set hidden
set sw=4 ts=4 expandtab background=dark
set hls
"set nowrap
" temporary- for giving this presentation
set wrap
set backspace=indent,eol,start
set autoindent
set copyindent
set showmatch
set incsearch
set history=10000
set undolevels=10000
set title
set visualbell
set noerrorbells


" TODO: testing this.  This means no annoying recovery from crashes, but also
" any unsaved work is ALWAYS lost.  Also, if I load large files, it all has to
" go into memory...maybe bad for large log files?
set nobackup
set noswapfile

" Because of the above lines, no longer need this:
" avoid shitting swapfiles all over
"set directory=$HOME/.vim/bak//

syntax on
filetype plugin indent on

" cool numbers bro!
set nu relativenumber
autocmd FileType taglist set nonu norelativenumber

" from https://www.youtube.com/watch?v=aHm36-na4-4
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%100v', 100)
call matchadd('ColorColumn', '\%120v', 100)

" make .page associated with markdown filetype
au BufRead,BufNewFile *.page set filetype=markdown

"set makeprg=~/bin/ghetto-make

set ttimeout
set ttimeoutlen=30


" show whitespace (http://vim.wikia.com/wiki/VimTip396)
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
" match trailing whitespace except when typing at the end of a line
match ExtraWhitespace /\s\+\%#\@<!$/

" flake8 settings (python pep8 checking)
" apt-get install flake8 if you don't have it
autocmd BufWritePost *.py call Flake8()

" shellcheck integration - https://jezenthomas.com/shell-script-static-analysis-in-vim/
au BufRead,BufNewFile *.sh set makeprg=shellcheck\ -x\ -f\ gcc\ %
autocmd BufWritePost *.sh :silent make | redraw!
au QuickFixCmdPost [^l]* nested cwindow
"au QuickFixCmdPost belowright cwindow 10
"au QuickFixCmdPost l* nested lwindow


" taglist settings
let Tlist_Auto_Open=0 "Auto open the list window
let Tlist_Compact_Format=1
let Tlist_Enable_Fold_Column=0 "Turn off the fold column for list window
let Tlist_Exit_OnlyWindow=1 "Exit if list is only window
let Tlist_File_Fold_Auto_Close=1
let Tlist_Show_Menu=1 "Show tag menu in gvim
let Tlist_Use_Right_Window = 1 "put list window on the rigth

map <silent> <Leader>tc :TlistClose<CR>
map <silent> <Leader>to :TlistOpen<CR>

" Write it no matter what!!!
" http://nvie.com/posts/how-i-boosted-my-vim/
cmap w!! w !sudo tee % >/dev/null

" Setup the status line to display the tagname, if the taglist plugin has been
" loaded
"autocmd VimEnter * try
"autocmd VimEnter *   call Tlist_Get_Tagname_By_Line()
"autocmd VimEnter *   set statusline=%f\ %y%{GetStatusEx()}[b:%n]\ [t:%{Tlist_Get_Tagname_By_Line()}]\ %m%r%=(%l/%L,%c%V)\ %P
"autocmd VimEnter *   map <silent> <Leader>tap :TlistAddFilesRecursive . *pm<CR>
"autocmd VimEnter * catch
"autocmd VimEnter * endt

" nvim stuffs:

if has('nvim')
    " https://github.com/neovim/neovim/wiki/FAQ#copying-to-x11-primary-selection-with-the-mouse-doesnt-work
    vnoremap <LeftRelease> "*ygv
endif

" fzf stuff
imap <c-x><c-l> <plug>(fzf-complete-line)
imap <c-x><c-f> <plug>(fzf-complete-file)
nnoremap <leader>p :History<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>c :Commits<CR>

" TODO: Commits ?
"
if has('nvim')
    " https://github.com/junegunn/fzf.vim
    function! s:fzf_statusline()
        " Override statusline as you like
        highlight fzf1 ctermfg=161 ctermbg=251
        highlight fzf2 ctermfg=23 ctermbg=251
        highlight fzf3 ctermfg=237 ctermbg=251
        setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
    endfunction

    autocmd! User FzfStatusLine call <SID>fzf_statusline()
endif

" COOL NEOVIM FEATURES!
if has("nvim")
    " show substitution commands live!  split => show preview in split window,
    " nosplit disables that
    set inccommand=split
endif

" highlighted yank plugin needs config if NOT neovim
if ! has("nvim")
    map y <Plug>(highlightedyank)
endif
