" File:			_vimrc
" Author:		hirakaku <hirakaku@gmail.com>

set nocompatible

" Plugin: neobundle {{{
filetype off

" Script: dotvim {{{
let $dotvim = expand('~/.vim')

if has('vim_starting')
	" git clone neobundle here!
	set runtimepath+=$dotvim/bundle/neobundle.vim
	let $bundle = expand('$dotvim/bundle')
	let $plugin = expand('$dotvim/plugin')
	call neobundle#rc($bundle)
endif
" }}}

" @ github {{{
NeoBundle 'fuenor/vim-wordcount'
NeoBundle 'gregsexton/VimCalc'
NeoBundle 'houtsnip/vim-emacscommandline'
NeoBundle 'kana/vim-smartchr'
NeoBundle 'kana/vim-textobj-indent'
NeoBundle 'kana/vim-textobj-lastpat'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'Shougo/echodoc'
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neocomplcache-snippets-complete'
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
NeoBundle 'tpope/vim-commentary'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-speeddating'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'vim-jp/vimdoc-ja'
NeoBundle 'vim-scripts/ShowMarks'
NeoBundle 'zhaocai/unite-scriptnames'
" }}}

" @ vim-scripts {{{
NeoBundle 'DirDiff.vim'
NeoBundle 'errormarker.vim'
NeoBundle 'sudo.vim'
NeoBundle 'YankRing.vim'
" }}}

" @ local {{{
source $plugin/textobj-fold.vim
" }}}
" }}}

filetype plugin on
filetype indent on

" Option: env {{{
" Option: os {{{
if has('win32') || has('win64')
	let $osname		= 'Windows'
	let $winhome	= $HOMEDRIVE . $HOMEPATH
	let $dotfiles	= $HOME . '/dotfiles'
	let $tmpdirs	= $TEMP
	let $msys			= $winhome . '/App/msys'
else
	let $osname		= system('uname')
	let $dotfiles	= '~/dotfiles'
	let $tmpdirs	= '~/tmp,/var/tmp,/tmp'
	let $tct			= '~/dev/scqemu/test/tct'

	colorscheme elflord
	set path=.,,/usr/local/include,/usr/include,./include
endif
" }}}

" language and encoding
set helplang=en,ja
set fileencodings=ucs-bom,utf-8,euc-jp,iso-2022-jp,cp932
set fileformats=unix,mac,dos

" input method
set iminsert=0
set imsearch=0

" Command: H {{{
command! -nargs=? -complete=help H
			\ h <args> | normal <C-w>L
" }}}

" Plugin: unite {{{
let unite_data_directory = $dotvim . '/.unite'
" }}}

" Plugin: vimfiler {{{
let vimfiler_data_directory = $dotvim . '/.vimfiler'
" }}}

" Plugin: vimshell {{{
let vimshell_temporary_directory = $dotvim . '/.vimshell'
" }}}

" Plugin: quickrun {{{
let quickrun_config = {}

let quickrun_config._ = {
			\ 'runner'		: 'vimproc',
			\ 'outputter'	: 'buffer',
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

let quickrun_config.scheme = {
			\ 'command'		: 'gosh',
			\ 'outputter'	: 'buffer',
			\ }

let quickrun_config.tct = {
			\ 'exec'			: ['%c %o %s %a',
			\ 'qemu-system-tct -nographic -kernel a.out 2>&1'],
			\ 'command'		: 'tct-elf-gcc',
			\ 'cmdopt'		: expand('-T $tct/tct.ld $tct/opc/crt0.s'),
			\ 'outputter'	: 'mixed',
			\ }

let quickrun_config['c.tct']		= quickrun_config.tct
let quickrun_config['asm.tct']	= quickrun_config.tct
" }}}

" Command: Call, Hook {{{
" Function: GetSIDs() {{{
function! GetSIDs(file)
	let file = empty(a:file) ? expand('%:p') : a:file

	redir => scriptnames
	silent! scriptnames
	redir END

	let sids = []
	let spat = '\v\s*(\d+):\s*(.*)$'
	let fpat = '\V'
				\ . substitute(file, '\\', '/', 'g')
				\ . '\v%(\.vim)?$'

	for s in split(scriptnames, "\n")
		let m = matchlist(s, spat)

		if empty(m) | continue | endif

		let [sid, script] = m[1 : 2]
		let script = fnamemodify(script, ':p:gs?\\?/?')

		if script =~# fpat
			call add(sids, sid)
		endif
	endfor

	return sids
endfunction
" }}}

" Function: GetFunction() {{{
function! GetFunction(file, fnname)
	let sid = get(GetSIDs(a:file), 0, '')
	return function('<SNR>' . sid . '_' . a:fnname)
endfunction
" }}}

" Function: Call() {{{
function! Call(f, ...)
	let [file, fnname] = (a:f =~# ':') ? split(a:f, ':') : [expand('%:p'), a:f]
	let sids = GetSIDs(file)

	for sid in sids
		if exists('*<SNR>' . sid . '_' . fnname)
			let fn = '<SNR>' . sid . '_' . fnname
			return call(fn, a:000)
		endif
	endfor

	echoerr 'Failed to call script local function: ' . a:f
	return -1
endfunction
" }}}

" Function: Hook() {{{
function! Hook(hooked, fn)
	let fnpat = "^function('\\(.*\\)')$"
	let hooked = (type(a:hooked) == 2)
				\ ? substitute(string(a:hooked), fnpat, '\1', '')
				\ : a:hooked
	let fn = (type(a:fn) == 2)
				\ ? substitute(string(a:fn), fnpat, '\1', '')
				\ : a:fn

	exe printf("function! %s(...)\n"
				\ . "\treturn call('%s', a:000)\n"
				\ . "endfunction",
				\ hooked, fn)
endfunction
" }}}

command! -nargs=+ Call echo Call(<f-args>)
command! -nargs=+ Hook call Hook(<f-args>)

" Test: :Call {{{
" :echo GetSIDs('')
" :let F = GetFunction('', 'Test') | echo F(0) => 1
" :Call Test 0 => 1
function! s:Test(nr)
	return a:nr + 1
endfunction
" }}}

" Test: :Hook {{{
" :Hook A B
" :call A() => Hello, B!
function! A()
	echo "Hello, A!"
endfunction

function! B()
	echo "Hello, B!"
endfunction
" }}}
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

" Plugin: Pyclewn {{{
let gdb_i386 = 'gdb'
let gdb_arm = 'arm-linux-gnueabi-gdb'

" Function: SetPyclewnArgs() {{{
function! SetPyclewnArgs(gdb, project)
	let g:pyclewn_gdb = a:gdb
	let g:pyclewn_args =
				\ '--gdb=async,' . a:project
				\ . ' --pgm=' . g:pyclewn_gdb
				\ . ' --window=top'
				\ . ' --maxlines=' . 1024 * 1024
				\ . ' --background=Cyan,Green,Magenta'
endfunction
" }}}

" Function: ToggleCmapkeys {{{
function! ToggleCmapkeys(gdb, project)
	if !has('netbeans_enabled')
		call SetPyclewnArgs(a:gdb, a:project)
		Pyclewn
		let g:pyclewn_mapped = 1 | Cmapkeys
	else
		if a:gdb != g:pyclewn_gdb || a:project != ''
			unlet g:pyclewn_mapped | nbclose
			call ToggleCmapkeys(a:gdb, a:project)
		else
			if g:pyclewn_mapped
				echo ':Cunmapkeys'
				let g:pyclewn_mapped = 0 | Cunmapkeys
			else
				echo ':Cmapkeys'
				let g:pyclewn_mapped = 1 | Cmapkeys
			endif
		endif
	endif
endfunction
" }}}

" Command: Cargs {{{
command! -nargs=? -complete=file Ci386 call ToggleCmapkeys(gdb_i386, '<args>')
command! -nargs=? -complete=file Carm call ToggleCmapkeys(gdb_arm, '<args>')
command! -nargs=* -complete=file Cargs Cset args <args>
" }}}
" }}}
" }}}

" Option: history {{{
let &history = 1024 * 1024
let $viminfo = $dotvim . '/.viminfo'
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
set directory=$tmpdirs

" backup
set backup
set backupdir=$tmpdirs

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
	if			&fenc == 'utf-8'				| let fenc = 'u'
	elseif	&fenc == 'euc-jp'				| let fenc = 'e'
	elseif	&fenc == 'cp932'				| let fenc = 'c'
	elseif	&fenc == 'iso-2022-jp'	| let fenc = 'i'
	else | let fenc = '-' | endif

	if			&ff == 'unix'	| let ff = 'u'
	elseif	&ff == 'mac'	| let ff = 'm'
	elseif	&ff == 'dos'	| let ff = 'w'
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
let indent_guides_guide_size	= 1
let indent_guides_auto_colors	= 0
highlight IndentGuidesOdd ctermbg=DarkRed
highlight IndentGuidesEven ctermbg=DarkBlue
" }}}

" parenthesis
set showmatch
set matchtime=3

" matchit
runtime macros/matchit.vim

" Plugin: YankRing {{{
let yankring_max_history		= 16
let yankring_window_height	= 11
let yankring_manage_numbered_reg = 1
let yankring_history_dir	= $dotvim
let yankring_history_file	= '.yankring'
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
let errormarker_errortext		= '!!'
let errormarker_warningtext	= '??'
let errormaker_errorgroup		= 'Error'
let Errormaker_warninggroup	= 'Todo'
" }}}
" }}}

" Option: search {{{
set hlsearch | :nohlsearch
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

" Plugin: necomplcache {{{
let neocomplcache_enable_at_startup = 1
let neocomplcache_temporary_dir	= $dotvim . '/.neco'
let neocomplcache_snippets_dir	= $dotvim . '/snip'
let neocomplcache_min_syntax_length = 3
let neocomplcache_enable_smart_case = 1
let neocomplcache_enable_camel_case_completion	= 1
let neocomplcache_enable_underbar_completion		= 1

" dictionaries {{{
let g:neocomplcache_dictionary_filetype_lists = {
			\ 'default'		: '',
			\ 'vimshell'	: '~/.zsh_history',
			\ }
" }}}

" keyword patterns {{{
if !exists('g:neocomplcache_keyword_patterns')
	let g:neocomplcache_keyword_patterns = {}
endif

let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
" }}}

" " omni patterns {{{
" if !exists('g:neocomplcache_omni_patterns')
" 	let g:neocomplcache_omni_patterns = {}
" endif
" 
" let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
" let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
" let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
" let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
" " }}}

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

vnoremap < <gv
vnoremap > >gv

nnoremap <C-w>e <C-w>=

inoremap <Esc>			<Esc>:set iminsert=0<CR>
nnoremap <ESC><ESC>	:noh<CR>

" quick edit {{{
let $vimrc				= $dotfiles . '/_vimrc'
let $gvimrc				= $dotfiles . '/_gvimrc'
let $nodokarc			= $dotfiles . '/dot.nodoka'
let $vimperatorrc	= $dotfiles . '/_vimperatorrc'

nnoremap <Leader>v		:e $vimrc<CR>
nnoremap <Leader>vv		:vnew $vimrc<CR>
nnoremap <Leader>vV		:tabe $vimrc<CR>
nnoremap <Leader>vg		:e $gvimrc<CR>
nnoremap <Leader>vgg	:vnew $gvimrc<CR>
nnoremap <Leader>vG		:tabe $gvimrc<CR>
nnoremap <Leader>vn		:e $nodokarc<CR>
nnoremap <Leader>vnn	:vnew $nodokarc<CR>
nnoremap <Leader>vN		:tabe $nodokarc<CR>
nnoremap <Leader>vp		:e $vimperatorrc<CR>
nnoremap <Leader>vpp	:vnew $vimperatorrc<CR>
nnoremap <Leader>vP		:tabe $vimperatorrc<CR>
nnoremap <Leader>vt		:e `=tempname()`<CR>
nnoremap <Leader>vT		:e `=strftime('%y%m%d-%H%M')`<CR>

nnoremap <Leader>V		:so %<CR>
nnoremap <Leader>Vh		:so $VIMRUNTIME/syntax/hitest.vim<CR>

nnoremap <Leader>:e :e %:h/
nnoremap <Leader>:n :new %:h/
nnoremap <Leader>:v :vnew %:h/
nnoremap <Leader>:t :tabe %:h/
" }}}

nnoremap <Leader>vc :Calc<CR>
nnoremap <Leader>vf :VimFiler<CR>
nnoremap <Leader>vF :FullScreen<CR>
nnoremap <Leader>vm :Make 
nnoremap <Leader>vs :w !sh<CR>
nnoremap <Leader>vw :w sudo:%
nnoremap <Leader>vx :set ft=xxd<CR>:%!xxd<CR>
nnoremap <Leader>vX :%!xxd -r<CR>:e!<CR>
" }}}

" Map: selection {{{
vnoremap <Leader>n ojok
vnoremap <Leader>N okoj
vnoremap a/ :<C-u>silent! normal! [/V]/<CR>
vnoremap a* :<C-u>silent! normal! [*V]*<CR>
vnoremap i/ :<C-u>silent! normal! [/jV]/k<CR>
vnoremap i* :<C-u>silent! normal! [*jV]*k<CR>
nnoremap <expr> gV '`[' . strpart(getregtype(), 0, 1) . '`]'
" }}}

" Map: expand {{{
inoremap <expr> <C-r>:: expand('%')
inoremap <expr> <C-r>:/ expand('%:p')
inoremap <expr> <C-r>:~ expand('%:~')
inoremap <expr> <C-r>:. expand('%:.')
inoremap <expr> <C-r>:f expand('%:t')
inoremap <expr> <C-r>:d expand('%:p:h')
" }}}

" Map: neobundle {{{
nnoremap <Leader>vbi :NeoBundleInstall<CR>
nnoremap <Leader>vbu :NeoBundleInstall! 
nnoremap <Leader>vbc :NeoBundleClean<CR>
nnoremap <Leader>vbd :NeoBundleDocs<CR>
nnoremap <Leader>vbl :NeoBundleList<CR>
" }}}

" Map: unite {{{
nnoremap <Leader>u		:Unite 
nnoremap <Leader>uf		:Unite file<CR>
nnoremap <Leader>ut		:Unite tag<CR>
nnoremap <Leader>utt	:Unite tag<CR>
nnoremap <Leader>utf	:Unite tag/file<CR>
nnoremap <Leader>ur		:Unite ref 
nnoremap <Leader>urm	:Unite ref/man<CR>
nnoremap <Leader>urpl	:Unite ref/perldoc<CR>
nnoremap <Leader>urpy	:Unite ref/pydoc<CR>
nnoremap <Leader>us		:Unite snippet<CR>
nnoremap <Leader>uv		:Unite scriptnames<CR>
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

" Map: Pyclewn {{{
nnoremap <Leader>c	:Ci386<CR>
nnoremap <Leader>cI	:Ci386<CR>
nnoremap <Leader>cA	:Carm<CR>
nnoremap <Leader>cS	:Csymcompletion<CR>
nnoremap <Leader>cP	:Cproject <C-r>=strftime('%y%m%d')<CR>.gdb
nnoremap <Leader>cq	:nbclose<CR>:bdelete (clewn)_console<CR>
nnoremap <Leader>cs	:Csigint<CR>
nnoremap <Leader>cp	:Cprint 
nnoremap <Leader>cb	:Cbreak 
vnoremap <Leader>cp	"*y:<C-u>Cprint <C-r>*<CR>
vnoremap <Leader>cb	"*y:<C-u>Cbreak <C-r>*<CR>
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

" " Map: smartchr {{{
" inoremap <expr> = smartchr#loop(' = ', '=', ' == ')
" inoremap <expr> , smartchr#one_of(', ', ',')
" " }}}

" Map: neocomplcache {{{
nnoremap <Leader>ns :NecoSnip 
nnoremap <Leader>nS :NecoRSnip 
imap <C-k> <Plug>(neocomplcache_snippets_expand)
smap <C-k> <Plug>(neocomplcache_snippets_expand)
inoremap <expr> <C-g> neocomplcache#undo_completion()
inoremap <expr> <C-l> neocomplcache#complete_common_string()
" inoremap <expr> <CR> neocomplcache#smart_close_popup() . "\<CR>"
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <C-h> neocomplcache#smart_close_popup() . "\<C-h>"
inoremap <expr> <C-h> neocomplcache#smart_close_popup() . "\<C-h>"
inoremap <expr> <C-y> pumvisible() ? neocomplcache#close_popup() : "\<C-y>"
inoremap <expr> <C-e> pumvisible() ? neocomplcache#cancel_popup() : "\<C-e>"
" }}}

" Augroup: {{{
augroup noname
	autocmd!
	autocmd VimEnter * set ts=4 sw=4 fenc=utf-8 ff=unix nomod
	autocmd BufNewFile,BufReadPost * setlocal ts=4 sw=4
	autocmd VimEnter * cmap <C-w> <M-BS>
	autocmd VimEnter *.snip setlocal filetype=snippet
	autocmd BufReadPost ~/dev/linux-stable/*
				\ set path^=~/dev/linux-stable/include
	autocmd BufReadPost *
				\ if line("'\"") > 1 && line("'\"") <= line('$')
				\ | exe "normal! g`\""
				\ | endif
augroup END
" }}}

" Augroup: filetype {{{
augroup filetype
	autocmd!
	autocmd FileType * setlocal formatoptions-=ro
	autocmd FileType help nnoremap <buffer> q <C-w>c
	autocmd FileType xml nnoremap <Leader>vf :%!xmllint --format -<CR>
	autocmd FileTYpe xml vnoremap <Leader>vf :!xmllint --format -<CR>
augroup END
" }}}

" Autocmd: nasty space {{{
highlight nasty_space ctermbg=Red guibg=Red
autocmd VimEnter,WinEnter,BufEnter * match nasty_space /　\|\s\+$/ 
" }}}

" Augroup: neocomplcache {{{
augroup neocomplcache
	autocmd!
	autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
	autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
	autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
	autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
	autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTagsinoremap
augroup END
" }}}

" vim: ts=2 sw=2 fenc=utf-8 ff=unix fdm=marker:
