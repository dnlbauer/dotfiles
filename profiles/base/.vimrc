call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'lervag/vimtex'
Plug 'ibab/vim-snakemake'
Plug 'Yggdroot/indentLine'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'morhetz/gruvbox'
Plug 'preservim/nerdcommenter'
call plug#end()

" Always show statusline 
set laststatus=2  

" Use 256 colours
set t_Co=256

" show linenumber
set number


let g:vim_markdown_folding_disabled = 1

syntax on
set softtabstop=4

set colorcolumn=80,100,120

colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'
set background=dark

" nerdcommenter
filetype plugin on
