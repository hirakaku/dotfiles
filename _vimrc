" File:			dotfiles/_vimrc
" Author:		hirakaku <hirakaku@gmail.com>
" Version:	v0.1a

set nocompatible
colorscheme elflord

" Plugin: neobundle {{{
filetype off

" Script: dotvim {{{
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
	let $bundle = expand('$dotvim/bundle')
	call neobundle#rc($bundle)
endif
" }}}

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
NeoBundle 'thinca/vim-poslist'
NeoBundle 'thinca/vim-visualstar'
NeoBundle 'vim-jp/vimdoc-ja'
NeoBundle 'vim-scripts/ShowMarks'

" @ vim-scripts
NeoBundle 'sudo.vim'
" }}}

filetype plugin on
filetype indent on

" Option: env {{{
set path=.,,/usr/local/include,/usr/include,./include
let $tmpdirs = '~/tmp,/var/tmp,/tmp'

" language and encoding
set helplang=en,ja
set fileencodings=iso-2022-jp,euc-jp,utf-8,cp932
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

" Plugin: poslist {{{
let g:poslist_histsize = 1024 * 1024
" }}}
" }}}

" Option: statusline {{{
set laststatus=2
set statusline=%<%f\ %y%q
set statusline+=%{'['.GetFencAndFF().']'}%w%m
set statusline+=\ %(%l,%c%)\ %L*%P

" Function: GetFencAndFF {{{
function! GetFencAndFF()
	if &fenc == 'utf-8' | let fenc = 'u'
	elseif &fenc == 'euc-jp' | let fenc = 'e'
	elseif &fenc == 'cp932' | let fenc = 'c'
	elseif &fenc == 'iso-2022-jp' | let fenc = 'i'
	else | let fenc = '-' | endif

	if &ff == 'unix' | let ff = 'u'
	elseif &ff == 'mac' | let ff = 'm'
	elseif &ff == 'dos' | let ff = 'w'
	else | let ff = '-' | endif

	return fenc . ff
endfunction
" }}}
" }}}

" Option: edit {{{
set number
set textwidth=0
set backspace=indent,eol,start

" parenthesis
set showmatch
set matchtime=3

" highlight nasty spaces
highlight nasty_space ctermbg=RED
match nasty_space /　\|\s\+$/
" }}}

" Option: mark {{{
" Plugin: ShowMarks {{{
let g:showmarks_include = "abcdefghijklmnopqrstuvwxyz"
let g:showmarks_include .= "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
let g:showmarks_include .= ".'`^<>[]{}()\""
highlight ShowMarksHLl ctermfg=Red ctermbg=DarkGray
highlight ShowMarksHLu ctermfg=Blue ctermbg=DarkGray
highlight ShowMarksHLo ctermfg=Gray ctermbg=DarkGray
highlight ShowMarksHLm ctermfg=White ctermbg=DarkGray
" }}}
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

	" Script: cscope.out auto detection {{{
	let dir = getcwd()
	while dir != '/'
		let g:cscope_file = dir . '/cscope.out'
		if filereadable(g:cscope_file)
			let g:cscope_dir = dir
			exe 'cscope add ' . g:cscope_file . ' ' . g:cscope_dir
			break
		endif
		let dir = fnamemodify(dir, ':h')
	endwhile

	if $CSCOPE_DB != ''
		cscope add $CSCOPE_DB
	endif

	set cscopeverbose
	" }}}
endif
" }}}
" }}}

" Option: completion {{{
" command-mode completion
set wildmenu
set wildmode=longest,list,full

" insert-mode completion
set showfulltag
set completeopt=longest,menuone,preview
" }}}

" Autocmd: {{{
augroup noname
	autocmd!
	autocmd BufEnter * lcd %:p:h
	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END
" }}}

" Autocmd: format {{{
augroup format
	autocmd!
	autocmd FileType * setlocal formatoptions-=ro
	autocmd FileType * setlocal ts=4 sw=4 fdm=marker
	autocmd FileType vim setlocal ts=2 sw=2 fdm=marker
	autocmd FileType help nnoremap <buffer> q <C-w>c
augroup END
" }}}

" Command: {{{
command! -nargs=? -complete=help H :h <args> || :normal <C-w>L
" }}}

let mapleader = ','

" Map: {{{
nnoremap j gj
nnoremap k gk

nnoremap <Leader>vf :VimFiler 
nnoremap <Leader>vw :w sudo:%

" vimrc
nnoremap <Leader>vv :e ~/.vimrc<CR>
nnoremap <Leader>V :so %<CR>
nnoremap <Leader>vt :e `=tempname()`<CR>
nnoremap <Leader>vT :e `=strftime('%y%m%d-%H%M')`<CR>

" xxd
nnoremap <Leader>vx :set ft=xxd<CR>:%!xxd<CR>
nnoremap <Leader>vX :%!xxd -r<CR>:e!<CR>

" expand
inoremap <expr> <C-r>:p expand('%')
inoremap <expr> <C-r>:f expand('%:p')
inoremap <expr> <C-r>:d expand('%:p:h')

" select pasted
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" }}}

" Map: neobundle {{{
nnoremap <Leader>vbl :NeoBundleList<CR>
nnoremap <Leader>vbi :NeoBundleInstall<CR>
nnoremap <Leader>vbc :NeoBundleClean<CR>
nnoremap <Leader>vbd :NeoBundleDocs<CR>
" }}}

" Map: poslist {{{
map <C-o> <Plug>(poslist-prev-pos)
map <C-i> <Plug>(poslist-next-pos)
map <C-S-o> <Plug>(poslist-prev-buf)
map <C-S-i> <Plug>(poslist-next-buf)
" }}}

" Map: visualstar {{{
map * <Plug>(visualstar-*)N
map # <Plug>(visualstar-#)N
" }}}

" Map: cscope {{{
if has('cscope')
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

" vim: ts=2 sw=2 fdm=marker
