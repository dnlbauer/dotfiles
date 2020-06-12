set rtp+=/usr/local/lib/python2.7/dist-packages/powerline/bindings/vim/  
" Always show statusline 
set laststatus=2  
" Use 256 colours (Use this setting only if your terminal supports 256 colours) 
set t_Co=256
set nocompatible              " be iMproved, required
set number

filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'kien/ctrlp.vim'
Plugin 'valloric/youcompleteme'
"Plugin 'davidhalter/jedi-vim'
"Plugin 'klen/python-mode'
Plugin 'biosyntax/biosyntax-vim'
Plugin 'hublot/vim-gromacs'
Plugin 'lervag/vimtex'
Plugin 'ibab/vim-snakemake'
Plugin 'Yggdroot/indentLine'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'morhetz/gruvbox'
Plugin 'preservim/nerdcommenter'
let g:vim_markdown_folding_disabled = 1

let g:pymode_python = "python3"
let g:pymode_virtualenv_path = "/home/bauer/conda"
let g:pymode = 1
let g:pymode_options = 1
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"

let g:ycm_autoclose_preview_window_after_completion=1

syntax on
set softtabstop=4

set colorcolumn=80,100,120

colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'
set background=dark

" nerdcommenter
filetype plugin on
