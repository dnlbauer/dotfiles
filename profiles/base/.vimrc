call plug#begin()
" ** style **
Plug 'vim-airline/vim-airline'
Plug 'morhetz/gruvbox'

"Plug 'Yggdroot/indentLine'
Plug 'nathanaelkane/vim-indent-guides'

" ** features **
Plug 'godlygeek/tabular'
Plug 'preservim/nerdcommenter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
nnoremap <C-f> :Files<Cr>
nnoremap <C-g> :Rg<Cr>

" ** syntax **
Plug 'elzr/vim-json'
Plug 'stephpy/vim-yaml'
Plug 'lervag/vimtex'
Plug 'ibab/vim-snakemake'
Plug 'plasticboy/vim-markdown'
Plug 'airblade/vim-gitgutter'
call plug#end()

" Always show statusline 
set laststatus=2  

" Use 256 colours
set t_Co=256

" show linenumber
set number

let g:vim_markdown_folding_disabled = 1

syntax on

filetype plugin indent on
" show tabs with 4 spaces width
set tabstop=4
" use 4 space to indent with '>'
set shiftwidth=4
" insert 4 spaces instead of tab
set expandtab

set colorcolumn=80,100,120

colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'
set background=dark

" nerdcommenter
filetype plugin on

" use conceals, but not on inserted lines
set conceallevel=2
set concealcursor=nc

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

set cursorline

autocmd FileType yml,yaml setlocal ts=2 sts=2 sw=2 expandtab
