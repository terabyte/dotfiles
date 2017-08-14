" TODO: http://nvie.com/posts/how-i-boosted-my-vim/


" Removing pathogen
"execute pathogen#infect()

" Replacing with vim-plug
call plug#begin('~/projects/vim')

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-markdown'
Plug 'terabyte/taglist.vim'

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
call plug#end()


set sw=4 ts=4 expandtab background=dark nu
set hidden

set hls
set background=dark

syntax on
filetype plugin indent on

" make .page associated with markdown filetype
au BufRead,BufNewFile *.page set filetype=markdown

set makeprg=~/bin/ghetto-make

" avoid shitting swapfiles all over
set directory=$HOME/.vim/bak//

set ttimeout
set ttimeoutlen=30

" cool numbers bro!
set number
set relativenumber

" show whitespace (http://vim.wikia.com/wiki/VimTip396)
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
" match trailing whitespace except when typing at the end of a line
match ExtraWhitespace /\s\+\%#\@<!$/

" taglist settings
let Tlist_Auto_Open=1 "Auto open the list window
let Tlist_Compact_Format=1
let Tlist_Enable_Fold_Column=0 "Turn off the fold column for list window
let Tlist_Exit_OnlyWindow=1 "Exit if list is only window
let Tlist_File_Fold_Auto_Close=1
let Tlist_Show_Menu=1 "Show tag menu in gvim
let Tlist_Use_Right_Window = 1 "put list window on the rigth

map <silent> <Leader>tc :TlistClose<CR>
map <silent> <Leader>to :TlistOpen<CR>

" nvim stuffs:
" turn off mouse in nivm
if has('nvim')
    "set-option -g mouse-utf8 off
endif

if has('nvim')
    " https://github.com/neovim/neovim/wiki/FAQ#copying-to-x11-primary-selection-with-the-mouse-doesnt-work
    vnoremap <LeftRelease> "*ygv
endif


