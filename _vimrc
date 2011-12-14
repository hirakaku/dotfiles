" File:			dotfiles/_vimrc
" Author:		hirakaku <hirakaku@gmail.com>
" Version:	v0.1

set nocompatible
colorscheme elflord

" Plugin: neobundle {{{
filetype off

if has('win32') || has('win64')
	let $osname = 'Windows'
	let $dotvim = expand('~/vimfiles')
else
	let $osname = system('uname')
	let $dotvim = expand('~/.vim')
endif

if has('vim_starting')
	" git clone neobundle here!
	set runtimepath+=$dotvim/bundle/neobundle.vim
	call neobundle#rc(expand('$dotvim/bundle'))
endif

" @ github
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/clang_complete'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/vinarise'
NeoBundle 'Shougo/echodoc'
" }}}

filetype plugin on
filetype indent on

" Option: path {{{
set path=.,,/usr/local/include,/usr/include,./include
let $tmpdirs = '~/tmp,/var/tmp,/tmp'
" }}}

" Option: language {{{
set helplang=ja,en
" }}}

" Option: encoding {{{
set fileencodings=utf-8,euc-jp,cp932,sjis
" }}}

" Option: history {{{
let &history = 1024 * 1024
let $viminfo = $dotvim . '/_viminfo'
set viminfo=!,%,'1024,c,h,n$viminfo

" undo
set undolevels=1024

" swap
set swapfile
set directory=$tmpdirs
" }}}

" Option: search {{{
set hlsearch
set incsearch
set ignorecase
set smartcase

" tag
set tags=./tags,tags;

" Feature: cscope {{{
if has('cscope')
	set cscopetag
	set cscopequickfix=t-,e-,s-,g-,c-,d-
	set nocscopeverbose

	let dir = getcwd() | let mod = ':h'
	while dir != '/'
		let g:cscope_file = dir . '/cscope.out'
		if filereadable(g:cscope_file)
			let g:cscope_dir = dir
			exe 'cscope add ' . g:cscope_file . ' ' . g:cscope_dir
			break
		endif
		let dir = fnamemodify(dir, mod)
	endwhile

	if $CSCOPE_DB != ''
		cscope add $CSCOPE_DB
	endif

	set cscopeverbose

	nnoremap <Leader>tf :cs find file 
	nnoremap <Leader>ti :cs find include 
	nnoremap <Leader>tt :cs find text 
	nnoremap <Leader>te :cs find egrep 
	nnoremap <Leader>ts :cs find symbol 
	nnoremap <Leader>tg :cs find global 
	nnoremap <Leader>tc :cs find calls 
	nnoremap <Leader>td :cs find called 
endif
" }}}
" }}}

" Option: completion {{{
set wildmenu
set wildmode=longest,list,full

" insert mode completion
set showfulltag
set completeopt=longest,menuone,preview
" }}}

" Option: edit {{{
set number
set textwidth=0

" space
set tabstop=4
set softtabstop=0
set shiftwidth=4
set backspace=indent,eol,start

" highlight undesirable spaces
highlight undesirable_space ctermbg=1
match undesirable_space /　\|\s\+$/

" parenthesis
set showmatch
set matchtime=3
" }}}

" vim: ts=2 sw=2 fdm=marker
