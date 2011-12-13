" File:		dotfiles/_vimrc
" Author:	hirakaku <hirakaku@gmail.com>
" Version:	v0.1

set nocompatible
colorscheme elflord

" Plugin: neobundle {{{
filetype off

if has('win32') || has('win64')
	let $dotvim = expand('~/vimfiles')
else
	let $dotvim = expand('~/.vim')
endif

if has('vim_starting')
	" git clone neobundle here!
	set runtimepath+=$dotvim/bundle/neobundle.vim
	call neobundle#rc(expand('$dotvim/bundle'))
endif

" @ github
NeoBundle 'Shougo/clang_complete'
NeoBundle 'Shougo/echodoc'
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vinarise'
" }}}

filetype plugin on
filetype indent on

" vim: ts=2 sw=2 fdm=marker
