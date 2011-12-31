" File:			dotfiles/_vimrc
" Author:		hirakaku <hirakaku@gmail.com>
" Version:	v0.1c

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

" @ github {{{
NeoBundle 'fuenor/vim-wordcount'
NeoBundle 'gregsexton/VimCalc'
NeoBundle 'houtsnip/vim-emacscommandline'
NeoBundle 'kana/vim-smartchr'
NeoBundle 'kana/vim-textobj-fold'
NeoBundle 'kana/vim-textobj-indent'
NeoBundle 'kana/vim-textobj-lastpat'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'nathanaelkane/vim-indent-guides'
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
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-visualstar'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-speeddating'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'vim-jp/vimdoc-ja'
NeoBundle 'vim-scripts/ShowMarks'
NeoBundle 'zhaocai/unite-scriptnames'
" }}}

" @ vim-scripts {{{
" NeoBundle 'autodate.vim'
NeoBundle 'DirDiff.vim'
NeoBundle 'errormarker.vim'
NeoBundle 'sudo.vim'
NeoBundle 'YankRing.vim'
" }}}
" }}}

filetype plugin on
filetype indent on

" Option: env {{{
set path=.,,/usr/local/include,/usr/include,./include
let $tmp_dirs = '~/tmp,/var/tmp,/tmp'
let $tct_dir = '~/dev/scqemu/test/tct'

" language and encoding
set helplang=en,ja
set fileencodings=iso-2022-jp,euc-jp,utf-8,cp932

" Command: H {{{
command! -nargs=? -complete=help H
			\ h <args> | normal <C-w>L
" }}}

" Command: Make {{{
" Function: FindBuild() {{{
function! FindBuild(dir)
	let dir = expand(a:dir)

	while dir != '/' && stridx(dir, '/') != -1
		let build = dir . '/build'

		if isdirectory(build)
			return build
		endif

		let dir = fnamemodify(dir, ':h')
	endwhile

	return ''
endfunction
" }}}

command! -nargs=? Make
			\ let b:build_dir = FindBuild(getcwd()) |
			\ | if b:build_dir != ''
				\ | echo b:build_dir
				\ | exe 'make -C ' . b:build_dir . ' <args>'
				\ | endif
" }}}

" Plugin: quickrun {{{
let quickrun_config = {}

let quickrun_config._ = {
			\ 'runner'		: 'vimproc',
			\ 'outputter'	: 'error',
			\ 'cmdopt'		: '%{b:cmdopt}',
			\ 'args'			: '%{b:args}',
			\ 'runner/vimproc/updatetime'	: 100,
			\ 'outputter/buffer/split'		: 'rightb 8sp',
			\ 'outputter/error/error'			: 'quickfix',
			\ }

" outputter mixed {{{
let quickrun_mixed = quickrun#outputter#multi#new()
let quickrun_mixed.config.targets = ['buffer', 'quickfix']

function! quickrun_mixed.init(session)
	cclose
	call call(quickrun#outputter#multi#new().init, [a:session], self)
endfunction

function! quickrun_mixed.finish(session)
	call call(quickrun#outputter#multi#new().finish, [a:session], self)
	bwipeout [quickrun
endfunction

call quickrun#register_outputter('mixed', quickrun_mixed)
" }}}

let quickrun_config.tct = {
			\ 'exec'			: ['%c %o %s %a',
			\ 'qemu-system-tct -nographic -kernel a.out 2>&1'],
			\ 'command'		: 'tct-elf-gcc',
			\ 'cmdopt'		: expand('-T $tct_dir/tct.ld $tct_dir/opc/crt0.s'),
			\ 'outputter'	: 'mixed',
			\ }

let quickrun_config['c.tct'] = quickrun_config.tct
let quickrun_config['asm.tct'] = quickrun_config.tct
" }}}
" }}}

" Option: history {{{
let &history = 1024 * 1024
let $viminfo = $dotvim . '/_viminfo'
set viminfo=!,%,'1024,c,h,n$viminfo

" undo
let &undolevels = 1024 * 1024

" Feature: persistent_undo {{{
if has('persistent_undo')
	let &undodir = $dotvim . '/.undo'
	set undofile
endif
" }}}

" swap
set swapfile
set directory=$tmp_dirs

" Plugin: poslist {{{
let poslist_histsize = 1024 * 1024
" }}}
" }}}

" Option: statusline {{{
set laststatus=2
set updatetime=60
set statusline=%f\ %y%q
set statusline+=%{'['.GetFencAndFF().']'}
set statusline+=%w%m
set statusline+=%<
set statusline+=[%{WordCount()}]
set statusline+=%=
set statusline+=%04l,%04v\ %L*%P

" Plugin: wordcount {{{
exe 'source ' . expand($dotvim) . '/bundle/vim-wordcount/wordcount.vim'
" }}}

" Function: GetFencAndFF() {{{
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

" Plugin: indent-guides {{{
" <Leader>ig => enable / disable
" let indent_guides_enable_on_vim_startup = 1
let indent_guides_guide_size = 1
let indent_guides_auto_colors = 0
highlight IndentGuidesOdd ctermbg=DarkRed
highlight IndentGuidesEven ctermbg=DarkBlue
" }}}

" parenthesis
set showmatch
set matchtime=3

" matchit
runtime macros/matchit.vim

" Plugin: YankRing {{{
let yankring_max_history = 16
let yankring_window_height = 11
let yankring_manage_numbered_reg = 1
let yankring_history_dir = expand('~/')
let yankring_history_file = '.vim_yankring'
" }}}
" }}}

" Option: mark {{{
" Plugin: ShowMarks {{{
let showmarks_include = 'abcdefghijklmnopqrstuvwxyz'
let showmarks_include .= 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
" let showmarks_include .= ".'`^<>[]{}()\""
let showmarks_ignore_name = 'hm'
highlight ShowMarksHLl ctermfg=Red ctermbg=DarkGray
highlight ShowMarksHLu ctermfg=Blue ctermbg=DarkGray
highlight ShowMarksHLo ctermfg=Gray ctermbg=DarkGray
highlight ShowMarksHLm ctermfg=White ctermbg=DarkGray
" }}}

" Plugin: errormarker {{{
let errormarker_errortext = '!!'
let errormarker_warningtext = '??'
let errormaker_errorgroup = 'Error'
let Errormaker_warninggroup = 'Todo'
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

	" Function: DetectCscopeOut() {{{
	function! DetectCscopeOut(dir)
		let dir = expand(a:dir)

		while dir != '/' && stridx(dir, '/') != -1
			let g:cscope_file = dir . '/cscope.out'

			if filereadable(g:cscope_file)
				let g:cscope_dir = dir
				exe 'cscope add ' . g:cscope_file . ' ' . g:cscope_dir
				return g:cscope_file
			endif

			let dir = fnamemodify(dir, ':h')
		endwhile

		return ''
	endfunction
	" }}}

	call DetectCscopeOut(getcwd())

	if $CSCOPE_DB != ''
		cscope add $CSCOPE_DB
	endif
endif
" }}}
" }}}

" Option: completion {{{
set wildmenu
set wildmode=longest,list,full

" insert-mode completion
set showfulltag
set completeopt=longest,menuone,preview

" " Plugin: autodate.vim {{{
" let autodate_keyword_pre = 'Update:'
" let autodate_keyword_post = '.'
" let autodate_format = '%y/%m/%d %T'
" " }}}

" Plugin: necomplcache {{{
let neocomplcache_enable_at_startup = 1
let neocomplcache_temporary_dir = $dotvim . '/.neocon'
let neocomplcache_snippets_dir = $dotvim . '/snip'
let neocomplcache_enable_underbar_completion = 1

" Command: neocomplcache {{{
command! -nargs=* NecoSnip NeoComplCacheEditSnippets <args>
command! -nargs=* NecoRSnip NeoComplCacheEditRuntimeSnippets <args>
" }}}
" }}}
" }}}

let mapleader = ','

" Map: {{{
nnoremap j gj
nnoremap k gk

nnoremap <Leader>:e :e %:h/
nnoremap <Leader>:n :new %:h/
nnoremap <Leader>:v :vnew %:h/
nnoremap <Leader>:t :tabe %:h/

nnoremap <Leader>vc :Calc<CR>
nnoremap <Leader>vf :VimFiler<CR>
nnoremap <Leader>vm :Make 
nnoremap <Leader>vs :w !sh<CR>
nnoremap <Leader>vw :w sudo:%

" vimrc
nnoremap <Leader>v	:e ~/.vimrc<CR>
nnoremap <Leader>vv	:vnew ~/.vimrc<CR><C-w>L
nnoremap <Leader>vV	:tabe ~/.vimrc<CR>
nnoremap <Leader>V	:so %<CR>

" scratch buffer
nnoremap <Leader>vt :e `=tempname()`<CR>
nnoremap <Leader>vT :e `=strftime('%y%m%d-%H%M')`<CR>

" xxd
nnoremap <Leader>vx :set ft=xxd<CR>:%!xxd<CR>
nnoremap <Leader>vX :%!xxd -r<CR>:e!<CR>

" highlight
nnoremap <Leader>vh :so $VIMRUNTIME/syntax/hitest.vim<CR>
nnoremap <ESC><ESC> :noh<CR>

" indent
vnoremap < <gv
vnoremap > >gv

" selection
vnoremap <Leader>n ojok
vnoremap <Leader>N okoj
vnoremap a/ :<C-u>silent! normal! [/V]/<CR>
vnoremap a* :<C-u>silent! normal! [*V]*<CR>
vnoremap i/ :<C-u>silent! normal! [/jV]/k<CR>
vnoremap i* :<C-u>silent! normal! [*jV]*k<CR>
nnoremap <expr> gV '`[' . strpart(getregtype(), 0, 1) . '`]'

" substitution
nnoremap ss		s
nnoremap se		ce<C-r>0<ESC>
nnoremap sE		cE<C-r>0<ESC>
nnoremap siw	ciw<C-r>0<ESC>
nnoremap siW	ciW<C-r>0<ESC>
nnoremap sC		C<c-r>0<ESC>
nnoremap sS		S<C-r>0<ESC>
nnoremap sp		S<C-r>0<ESC>
vnoremap ss		s
vnoremap sp		c<C-r>0<ESC>

" expand
inoremap <expr> <C-r>:: expand('%')
inoremap <expr> <C-r>:/ expand('%:p')
inoremap <expr> <C-r>:~ expand('%:~')
inoremap <expr> <C-r>:. expand('%:.')
inoremap <expr> <C-r>:f expand('%:t')
inoremap <expr> <C-r>:d expand('%:p:h')
" }}}

" Map: neobundle {{{
nnoremap <Leader>vbi :NeoBundleInstall<CR>
nnoremap <Leader>vbc :NeoBundleClean<CR>
nnoremap <Leader>vbd :NeoBundleDocs<CR>
nnoremap <Leader>vbl :NeoBundleList<CR>
" }}}

" Map: unite {{{
nnoremap <Leader>u		:Unite 
nnoremap <Leader>ut		:Unite tag<CR>
nnoremap <Leader>utt	:Unite tag<CR>
nnoremap <Leader>utf	:Unite tag/file<CR>
nnoremap <Leader>ur		:Unite ref 
nnoremap <Leader>urm	:Unite ref/man<CR>
nnoremap <Leader>urpl :Unite ref/perldoc<CR>
nnoremap <Leader>urpy :Unite ref/pydoc<CR>
nnoremap <Leader>uv		:Unite scriptnames<CR>
nnoremap <Leader>us		:Unite snippet<CR>
" }}}

" Map: fugitive {{{
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gl :Git log<CR>
nnoremap <Leader>gt :Git tag<CR>
nnoremap <Leader>gd :Gdiff<CR>
" }}}

" Map: quickrun {{{
map <Leader>r :QuickRun<CR>
" }}}

" Map: EasyMotion {{{
let EasyMotion_leader_key = '_'
nnoremap __ _
" }}}

" Map: poslist {{{
map <C-o> <Plug>(poslist-prev-pos)
map <C-i> <Plug>(poslist-next-pos)
map <Leader><C-o> <Plug>(poslist-prev-buf)
map <Leader><C-i> <Plug>(poslist-next-buf)
" }}}

" Map: YankRing {{{
nnoremap yr :YRShow<CR>
nnoremap yc :YRClear<CR>
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

" Map: smartchr {{{
inoremap <expr> = smartchr#loop(' = ', '=', ' == ')
inoremap <expr> , smartchr#one_of(', ', ',')
" }}}

" Map: neocomplcache {{{
nnoremap <Leader>ns :NecoSnip 
nnoremap <Leader>nS :NecoRSnip 
imap <C-k> <Plug>(neocomplcache_snippets_expand)
smap <C-k> <Plug>(neocomplcache_snippets_expand)
" }}}

" Autocmd: {{{
augroup noname
	autocmd!
	autocmd VimEnter * cmap <C-w> <M-BS>
	" autocmd BufEnter * lcd %:p:h
	autocmd BufReadPost ~/dev/linux-stable/*
				\	set path^=~/dev/linux-stable/include
	autocmd BufReadPost *
				\	if line("'\"") > 1 && line("'\"") <= line('$')
				\	| exe "normal! g`\""
				\	| endif
augroup END
" }}}

" Autocmd: FileType {{{
augroup filetype
	autocmd!
	autocmd FileType * setlocal formatoptions-=ro
	" autocmd FileType * setlocal ts=4 sw=4 fdm=marker
	" autocmd FileType vim setlocal ts=2 sw=2 fdm=marker
	autocmd FileType help nnoremap <buffer> q <C-w>c
augroup END
" }}}

" Autocmd: nasty space {{{
highlight nasty_space ctermbg=RED
autocmd VimEnter,WinEnter * match nasty_space /　\|\s\+$/
" }}}

" vim: ts=2 sw=2 fdm=marker
