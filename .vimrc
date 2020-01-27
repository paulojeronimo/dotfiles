" Author: Paulo Jerônimo (@paulojeronimo, pj@paulojeronimo.info)
" File ~/.vimrc (Vim configurations) in pj@pj-macbookpro

call pathogen#infect()
syntax enable
filetype plugin indent on
set expandtab
set tabstop=2
set shiftwidth=2
set number
set modelines=5
set encoding=utf-8
colorscheme desert

" http://bit.ly/37tB1Ne
" 60 columns asciidoc files
au BufRead,BufNewFile *.adoc setlocal textwidth=60

" https://stackoverflow.com/a/3765575
set colorcolumn=60
