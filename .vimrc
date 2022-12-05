set nocompatible " be iMproved, required by Vundle
filetype off     " required by Vundle

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'slim-template/vim-slim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'digitaltoad/vim-pug'
Plugin 'isruslan/vim-es6'
Plugin 'tomlion/vim-solidity'
Plugin 'scrooloose/nerdtree'
Plugin 'sukima/vim-tiddlywiki'
Plugin 'jxnblk/vim-mdx-js'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'vmchale/dhall-vim'
Plugin 'leafgarland/typescript-vim'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'vito-c/jq.vim'
Plugin 'udalov/kotlin-vim'
Plugin 'aklt/plantuml-syntax'             " syntax hl for puml
Plugin 'tyru/open-browser.vim'            " hooks for opeing browser
Plugin 'weirongxu/plantuml-previewer.vim' " previewer
Plugin 'cespare/vim-toml'
call vundle#end()

syntax enable
filetype plugin indent on
set expandtab
set tabstop=2
set shiftwidth=2
set number
set modelines=5
set encoding=utf-8
set hlsearch ignorecase
colorscheme desert

" http://bit.ly/37tB1Ne
" https://stackoverflow.com/a/3765575
au BufRead,BufNewFile *.adoc setlocal textwidth=72 colorcolumn=72
au BufRead,BufNewFile *.js setlocal textwidth=80 colorcolumn=80

" https://vi.stackexchange.com/a/430
"set list
set nowrap
if has('gui_running')
  set listchars=eol:⏎,tab:▶\ ,trail:·,extends:\#,nbsp:.
else
  set listchars=eol:⏎,tab:>.,trail:.,extends:\#,nbsp:.
endif

set belloff=all
set noswapfile
set autoread
set noignorecase
