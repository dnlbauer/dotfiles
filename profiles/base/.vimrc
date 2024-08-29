syntax on  " syntax highlighting
filetype plugin indent on  " enable filetype dependent features

set noswapfile  " disable swap file

set number  " show line numbers
set cursorline  " highlight line of cursor
set conceallevel=2  " hide syntac elements, i.e. the quotations in json

set hlsearch  " highlight all search results
set ignorecase  " search case insensitive
set incsearch  " incremental search

set tabstop=4  " show tabs as 4 spaces
set shiftwidth=4  " indent by 4 spaces with <, > keys
set expandtab  " indent by 4 spaces with tab
set colorcolumn=80,100,120  " color column


call plug#begin()
Plug 'vim-airline/vim-airline'  " colored status line at bottom
Plug 'morhetz/gruvbox'  " theme
Plug 'nathanaelkane/vim-indent-guides'  " indentation lines

" ** features **
Plug 'preservim/nerdcommenter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
nnoremap <C-f> :Files<Cr>
nnoremap <C-g> :Rg<Cr>

" ** syntax **
Plug 'https://github.com/elzr/vim-json.git'
Plug 'stephpy/vim-yaml'
Plug 'lervag/vimtex'
Plug 'ibab/vim-snakemake'
Plug 'plasticboy/vim-markdown'
Plug 'airblade/vim-gitgutter'

Plug 'fmoralesc/vim-tutor-mode'
call plug#end()

let g:vim_markdown_folding_disabled = 1

colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'
set background=dark


let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1


" yaml spacing
autocmd FileType yml,yaml setlocal ts=2 sts=2 sw=2 expandtab

" json autocmds
augroup json_autocmd
  autocmd!
  autocmd FileType json set autoindent
  autocmd FileType json set formatoptions=tcq2l
  autocmd FileType json set textwidth=78 shiftwidth=2
  autocmd FileType json set softtabstop=2 tabstop=8
  autocmd FileType json set expandtab
  autocmd FileType json set foldmethod=syntax
augroup END
