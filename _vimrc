" File:		dotfiles/_vimrc
" Author:	hirakaku <hirakaku@gmail.com>

set nocompatible

" Plugin: neobundle {{{
filetype off
" Feature: vim_starting {{{
if has('vim_starting')
	let $dotfiles	= expand('~/dotfiles')
	let $dotvim		= expand('~/.vim')
	let $bundle		= expand('$dotvim/bundle')
	let $plugin		= expand('$dotvim/plugin')

	set runtimepath+=$dotvim/bundle/neobundle.vim
	call neobundle#rc($bundle)
endif
" }}}

" @ github {{{
if !has('win32') && !has('win64')
	NeoBundle 'Shougo/vimproc'
endif

" NeoBundle 'vim-scripts/YankRing.vim'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'Shougo/echodoc'
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neocomplcache-snippets-complete'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vinarise'
NeoBundle 'fuenor/qfixgrep'
NeoBundle 'fuenor/vim-wordcount'
NeoBundle 'gregsexton/VimCalc'
NeoBundle 'guns/xterm-color-table.vim'
NeoBundle 'houtsnip/vim-emacscommandline'
NeoBundle 'kana/vim-smartchr'
NeoBundle 'kana/vim-textobj-indent'
NeoBundle 'kana/vim-textobj-lastpat'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'taku-o/vim-zoom'
NeoBundle 'tclem/vim-arduino'
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
NeoBundle 'vim-scripts/DirDiff.vim'
NeoBundle 'vim-scripts/Quich-Filter'
NeoBundle 'vim-scripts/ShowMarks'
NeoBundle 'vim-scripts/ShowMultiBase'
NeoBundle 'vim-scripts/errormarker.vim'
NeoBundle 'vim-scripts/sudo.vim'
NeoBundle 'vim-scripts/taglist.vim'
NeoBundle 'vim-scripts/wokmarks.vim'
NeoBundle 'zhaocai/unite-scriptnames'
" }}}

" @ local {{{
runtime ftplugin/man.vim
runtime macros/matchit.vim

source $dotvim/bundle/vim-wordcount/wordcount.vim
source $plugin/textobj-fold.vim
" }}}
" }}}

filetype plugin on
filetype indent on
syntax on

" Option: env {{{
" Option: os {{{
if has('win32') || has('win64')
	let $osname		= 'Windows'
	let $winhome	= $HOMEDRIVE . $HOMEPATH
	let $tmpdirs	= $TEMP
	let $app			= $home . '/app'
	let $msys			= $app . '/mingw/msys/1.0'
	let $cygwin		= $app . '/cygwin'
	let $vimproc	= $bundle . '/vimproc'

	if isdirectory($msys)
		set shell=$msys/bin/sh.exe\ --login
	elseif isdirectory($cygwin)
		set shell=$cygwin/bin/sh.exe\ --login
	endif
else
	let $osname		= system('uname')
	let $tmpdirs	= '~/tmp,/var/tmp,/tmp'

	colorscheme jellybeans

	set path=.,,/usr/local/include,/usr/include,./include
endif
" }}}

" language and encoding
set helplang=ja,en
set fileencodings=ucs-bom,utf-8,euc-jp,iso-2022-jp,cp932
set fileformats=unix,mac,dos

" input method
set iminsert=0
set imsearch=0

" help {{{
" Command: H {{{
command! -nargs=? -complete=help H
			\ h <args> | normal <C-w>L
" }}}

" Plugin: vim-ref {{{
let ref_open = ':rightb vsplit'
let ref_cache_dir = $dotvim . '/.vimref'

cnoreabbrev rman	Ref man
cnoreabbrev rpl		Ref perldoc
cnoreabbrev rpy		Ref pydoc

function! s:init_vimref() " {{{
	nnoremap <buffer> b <Plug>(ref-back)
	nnoremap <buffer> f <Plug>(ref-forward)
	nnoremap <buffer> q <C-w>c
endfunction
" }}}
" }}}
" }}}

" statusline {{{
set laststatus=2
set updatetime=60

function! GetFencAndFF() " {{{
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

set statusline=%f\ %y%q
set statusline+=%{'['.GetFencAndFF().']'}
set statusline+=%w%m
set statusline+=%<
set statusline+=[%{WordCount()}]
set statusline+=%=
set statusline+=%04l,%04v\ %L*%P
" }}}

" Feature: quickfix {{{
if has('quickfix')
	cnoreabbrev vcope rightb cope 80
endif
" }}}

" Plugin: unite {{{
let unite_data_directory = $dotvim . '/.unite'
" }}}

" Plugin: vimfiler {{{
let vimfiler_as_default_explorer	= 1
let vimfiler_safe_mode_by_default	= 0
let vimfiler_data_directory = $dotvim . '/.vimfiler'
" }}}

" Plugin: vimshell {{{
let vimshell_temporary_directory = $dotvim . '/.vimshell'
" }}}

" Plugin: quickrun {{{
let g:quickrun_no_default_key_mappings = 0

" config {{{
let quickrun_config = {}

let quickrun_config._ = {
			\ 'runner'		: 'vimproc',
			\ 'outputter'	: 'buffer',
			\ 'cmdopt'		: '%{b:cmdopt}',
			\ 'args'			: '%{b:args}',
			\ 'runner/vimproc/updatetime'	: 100,
			\ 'outputter/buffer/split'		: 'rightb 8split',
			\ 'outputter/error/error'			: 'quickfix',
			\ }
" }}}

" mixed outputter {{{
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

let quickrun_config.c = {
			\ 'runner'	: 'vimproc',
			\ 'command'	: 'gcc',
			\ 'cmdopt'	: '-g',
			\ 'exec'		: ['%c %o %s -o %s:p:r'],
			\ }

let quickrun_config.scheme = {
			\ 'command'		: 'gosh',
			\ 'outputter'	: 'buffer',
			\ }
" }}}

" Plugin: Pyclewn {{{
" Package: sourceforge.net/projects/pyclewn/files/pyclewn-1.9/pyclewn-1.9.py2.tar.gz
let gdb_i386 = 'gdb'
let gdb_arm = 'arm-linux-gnueabi-gdb'

function! SetPyclewnArgs(gdb, project) " {{{
	let g:pyclewn_gdb = a:gdb

	let g:pyclewn_args =
				\ '--gdb=async,' . a:project
				\ . ' --pgm=' . g:pyclewn_gdb
				\ . ' --window=top'
				\ . ' --maxlines=' . 1024 * 1024
				\ . ' --background=Cyan,Green,Magenta'
endfunction
" }}}

function! ToggleCmapkeys(gdb, project) " {{{
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

" Command: Tcd {{{
let g:tcd = ""

command! -nargs=0 Tcd
			\		if !empty(g:tcd)
			\ |		if isdirectory(g:tcd)
			\ |			exe 'lcd ' . expand(g:tcd)
			\ |		endif
			\
			\ |		let g:tcd = ""
			\ |	else
			\ |		let g:tcd = getcwd()
			\ |		lcd %:p:h
			\ |	endif
" }}}

" Command: Make {{{
function! FindBuild(dir) " {{{
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
			\		let b:build_dir = FindBuild(getcwd()) |
			\ |		if b:build_dir != ''
			\ |		echo b:build_dir
			\ |		exe 'make -C ' . b:build_dir . ' <args>'
			\ |	endif
" }}}

" Command: Call, Hook {{{
function! GetSIDs(file) " {{{
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

function! GetFunction(file, fnname) " {{{
	let sid = get(GetSIDs(a:file), 0, '')
	return function('<SNR>' . sid . '_' . a:fnname)
endfunction
" }}}

function! Call(f, ...) " {{{
	let [file, fnname] = (a:f =~# ':')
				\ ? split(a:f, ':')
				\ : [expand('%:p'), a:f]

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

function! Hook(hooked, fn) " {{{
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
	echo 'Hello, A!'
endfunction

function! B()
	echo 'Hello, B!'
endfunction
" }}}
" }}}

" Command: DiffVimVer {{{
function! s:diff_vim_ver(diffed) " {{{
	if a:diffed == ''
		let diffed = expand('~/bin/vim')
	else
		let diffed = expand(a:diffed)
	endif

	if !filereadable(diffed)
		echoerr 'Not found: ' . diffed
		return -1
	endif

	silent tabe current
	silent read !vim --version
	silent v/^\s*[+-].*/d
	silent %s/\v([+-]{1,2}[0-9a-zA-Z_()]+)\s+\n*/\1\r/g
	silent %!sort
	set nomodified
	diffthis

	silent rightb vert diffsplit diffed
	silent exe 'read !' . diffed . ' --version'
	silent v/^\s*[+-].*/d
	silent %s/\v([+-]{1,2}[0-9a-zA-Z_()]+)\s+\n*/\1\r/g
	silent %!sort
	set nomodified
	diffupdate
endfunction
" }}}

command! -nargs=? DiffVimVer call s:diff_vim_ver('<args>')
" }}}

" Command: ShowColors {{{
function! s:show_colors()
	tabe colors

	let num = 255

	while num >= 0
		exec 'hi col_' . num . ' ctermbg=' . num . ' ctermfg=white'
		exec 'syn match col_' . num . ' "ctermbg='. num . ':..." containedIn=ALL'
		call append(0, 'ctermbg=' . num . ':...')
		set nomodified

		let num -= 1
	endwhile
endfunction

command! -nargs=0 ShowColors call s:show_colors()
" }}}
" }}}

" Option: edit {{{
set number
set textwidth=0
set backspace=indent,eol,start
set hidden

" Plugin: indent-guides {{{
" <Leader>ig => toggle indent guides
" let indent_guides_enable_on_vim_startup = 1
let indent_guides_guide_size	= 1
let indent_guides_auto_colors	= 0

highlight IndentGuidesOdd ctermbg=DarkRed
highlight IndentGuidesEven ctermbg=DarkBlue
" }}}

" parenthesis
set showmatch
set matchtime=3

" Plugin: ShowMultiBase {{{
" Help: $bundle/ShowMultiBase/README
" \=				=> base auto
" \b/o/d/h=	=> base 2/8/10/16
let ShowMultiBase_Register_UnnamedBase		= 0
let ShowMultiBase_Register_ClipboardBase	= 0
" }}}

" Plugin: YankRing {{{
let yankring_max_history		= 16
let yankring_window_height	= 11
let yankring_manage_numbered_reg		= 1
let yankring_manual_clipboard_check	= 0
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

highlight ShowMarksHLl ctermfg=Red ctermbg=Black
highlight ShowMarksHLu ctermfg=Blue ctermbg=Black
highlight ShowMarksHLo ctermfg=Gray ctermbg=Black
highlight ShowMarksHLm ctermfg=White ctermbg=Black
" }}}

" Plugin: wokmarks {{{
" Help: $bundle/wokmarks.vim/README
" tm		=> set mark
" tt		=> toggle mark
" tl		=> list marks
" tj/k	=> jump to above/below mark
" tD		=> delete marks
let wokmarks_do_maps = 1
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

	function! DetectCscopeOut(dir) " {{{
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

" Plugin: taglist {{{
let Tlist_Show_One_File		= 1
let Tlist_Exit_OnlyWindow	= 1
let Tlist_Auto_Highlight_Tag = 1
let Tlist_GainFocus_On_ToggleOpen = 1
" }}}

" Plugin: Quich-Filter {{{
let filteringDefaultContextLines = 0
" }}}

" Plugin: QFixGrep {{{
let QFix_UseLocationList = 0
let QFix_CopenCmd = ''
let QFix_Width = 0
let QFix_CursorLine		= 1
let QFix_CloseOnJump	= 0
let QFix_Edit = 'tab'

let QFix_PreviewEnable	= 0
let QFix_PreviewExclude	= '\.exe$\|\.out$'
let QFix_PreviewOpenCmd	= ''
let QFix_PreviewHeight = 0
let QFix_PreviewFtypeHighlight = 1
let QFix_PreviewCursorLine = 1
let QFix_PreviewWrap = 0

let MyGrep_Key	= 'g'
let MyGrep_KeyB	= '<Leader>'
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

" Option: history {{{
let &history = 1024 * 1024
let $viminfo = $dotvim . '/.viminfo'
set viminfo=!,%,'1024,c,h,n$viminfo

" undo
let &undolevels = 1024 * 1024

" Feature: persistent_undo {{{
if has('persistent_undo')
	set undodir=$dotvim/.undo
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

let mapleader = ','

" Map: {{{
nnoremap j gj
nnoremap k gk

" special keys {{{
map		<Esc>OA <Up>
map		<Esc>OB <Down>
map		<Esc>OC <Right>
map		<Esc>OD <Left>
map		<Esc>OH 0
map		<Esc>OF $
cmap	<Esc>OH <C-a>
cmap	<Esc>OF <C-e>
imap	<Esc>OH <C-o>0
imap	<Esc>OF <C-o>$
" }}}

vnoremap < <gv
vnoremap > >gv

nnoremap <C-w>e <C-w>=

inoremap <Esc>			<Esc>:set iminsert=0<CR>
nnoremap <Esc><Esc>	:noh<CR>

nnoremap <Leader>vc :Calc<CR>
nnoremap <Leader>vf :VimFiler<CR>
nnoremap <Leader>vF :FullScreen<CR>
nnoremap <Leader>vl :set list!<CR>
nnoremap <Leader>vm :Make<Space>
nnoremap <Leader>vn :NERDTree<CR>
nnoremap <Leader>vs :w !sh<CR>
nnoremap <Leader>vw :w sudo:%
nnoremap <Leader>vx :set ft=xxd<CR>:%!xxd<CR>
nnoremap <Leader>vX :%!xxd -r<CR>:e!<CR>

nnoremap <Leader>V	:so %<CR>
nnoremap <Leader>Vh	:so $VIMRUNTIME/syntax/hitest.vim<CR>
" }}}

" Map: quick-e {{{
let $vimrc				= $dotfiles . '/_vimrc'
let $gvimrc				= $dotfiles . '/_gvimrc'
let $vimperatorrc	= $dotfiles . '/_vimperatorrc'
let $nodokarc			= $dotfiles . '/dot.nodoka'
let $tmuxrc				= $dotfiles . '/tmux.conf'
let $zshrc				= $dotfiles . '/_zshrc'

nnoremap <Leader>v		:e $vimrc<CR>
nnoremap <Leader>vv		:vnew $vimrc<CR>
nnoremap <Leader>vV		:tabe $vimrc<CR>
nnoremap <Leader>eg		:e $gvimrc<CR>
nnoremap <Leader>egg	:vnew $gvimrc<CR>
nnoremap <Leader>eG		:tabe $gvimrc<CR>
nnoremap <Leader>ep		:e $vimperatorrc<CR>
nnoremap <Leader>epp	:vnew $vimperatorrc<CR>
nnoremap <Leader>eP		:tabe $vimperatorrc<CR>
nnoremap <Leader>en		:e $nodokarc<CR>
nnoremap <Leader>enn	:vnew $nodokarc<CR>
nnoremap <Leader>eN		:tabe $nodokarc<CR>
nnoremap <Leader>et		:e $tmuxrc<CR>
nnoremap <Leader>ett	:vnew $tmuxrc<CR>
nnoremap <Leader>eT		:tabe $tmuxrc<CR>
nnoremap <Leader>ez		:e $zshrc<CR>
nnoremap <Leader>ezz	:vnew $zshrc<CR>
nnoremap <Leader>eZ		:tabe $zshrc<CR>

nnoremap <Leader>er		:e `=tempname()`<CR>
nnoremap <Leader>err	:vnew `=tempname()`<CR>
nnoremap <Leader>eR		:tabe `=tempname()`<CR>
nnoremap <Leader>ed		:e `=strftime('%y%m%d-%H%M')`<CR>
nnoremap <Leader>edd	:vnew `=strftime('%y%m%d-%H%M')`<CR>
nnoremap <Leader>eD		:tabe `=strftime('%y%m%d-%H%M')`<CR>

nnoremap <Leader>:e :e %:h/
nnoremap <Leader>:n :new %:h/
nnoremap <Leader>:v :vnew %:h/
nnoremap <Leader>:t :tabe %:h/
" }}}

" Map: tab {{{
nnoremap Te :tabe 
nnoremap Tt :tabe<CR>
nnoremap TT :tabe<CR>
nnoremap Th :tab help 
nnoremap Td :tabd 
nnoremap Tc :tabc<CR>
nnoremap To :tabo<CR>
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

" Map: substitution {{{
vnoremap <Leader>st :s/\t\+/ /g
" }}}

" Map: neobundle {{{
nnoremap <Leader>vbi :NeoBundleInstall<CR>
nnoremap <Leader>vbu :NeoBundleInstall!<Space>
nnoremap <Leader>vbc :NeoBundleClean<CR>
nnoremap <Leader>vbd :NeoBundleDocs<CR>
nnoremap <Leader>vbl :NeoBundleList<CR>
" }}}

" Map: unite {{{
nnoremap <Leader>u		:Unite<Space>
nnoremap <Leader>uf		:Unite file<CR>
nnoremap <Leader>ut		:Unite tag<CR>
nnoremap <Leader>utt	:Unite tag<CR>
nnoremap <Leader>utf	:Unite tag/file<CR>
nnoremap <Leader>ur		:Unite ref<Space>
nnoremap <Leader>urm	:Unite ref/man<CR>
nnoremap <Leader>urp	:Unite ref/perldoc<CR>
nnoremap <Leader>ury	:Unite ref/pydoc<CR>
nnoremap <Leader>us		:Unite snippet<CR>
nnoremap <Leader>uv		:Unite scriptnames<CR>
nnoremap <Leader>un		:Unite neobundle<CR>
nnoremap <Leader>unn	:Unite neobundle<CR>
nnoremap <Leader>uni	:Unite neobundle/install:
nnoremap <Leader>unl	:Unite neobundle/log<CR>
" }}}

" Map: fugitive {{{
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gl :Git log<CR>
nnoremap <Leader>gt :Git tag<CR>
nnoremap <Leader>gd :Gdiff<CR>
" }}}

" Map: quickrun {{{
nnoremap <Leader>ra :QuickRun -args 
" }}}

" Map: Pyclewn {{{
nnoremap <Leader>c	:Ci386<CR>
nnoremap <Leader>cI	:Ci386<CR>
nnoremap <Leader>cA	:Carm<CR>
nnoremap <Leader>cS	:Csymcompletion<CR>
nnoremap <Leader>cP	:Cproject <C-r>=strftime('%y%m%d')<CR>.gdb
nnoremap <Leader>cq	:nbclose<CR>:bdelete (clewn)_console<CR>
nnoremap <Leader>cs	:Csigint<CR>
nnoremap <Leader>cp	:Cprint<Space>
nnoremap <Leader>cb	:Cbreak<Space>
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

" Map: taglist {{{
nnoremap <Leader>t :TlistToggle<CR>
" }}}

" Map: cscope {{{
if has('cscope')
	nnoremap <Leader>tf :cs find file<Space>
	nnoremap <Leader>ti :cs find include<Space>
	nnoremap <Leader>tt :cs find text<Space>
	nnoremap <Leader>te :cs find egrep<Space>
	nnoremap <Leader>ts :cs find symbol<Space>
	nnoremap <Leader>tg :cs find global<Space>
	nnoremap <Leader>tc :cs find calls<Space>
	nnoremap <Leader>td :cs find called<Space>
endif
" }}}

" Map: Quich-Filter {{{
function! s:filtering() " {{{
	let obj = FilteringNew()
	call obj.addToParameter('alt', @/)
	call obj.run()
endfunction
" }}}

function! s:filtering_input() " {{{
	let obj = FilteringNew()
	let query = input('> ')

	if empty(query) | return | endif

	call obj.parseQuery(query, '|')
	call obj.run()
endfunction
" }}}

nnoremap <Leader>f	:call <SID>filtering()<CR>
nnoremap <Leader>ff	:call <SID>filtering()<CR>
nnoremap <Leader>fi	:call <SID>filtering_input()<CR>
nnoremap <Leader>fr	:call FilteringGetForSource().return()<CR>
" }}}

" Map: smartchr {{{
cnoremap <expr> %
			\ smartchr#loop('%', '%:h', '%:p', {'ctype': ':', 'fallback': '%'})
cnoremap <expr> /
			\ smartchr#loop('/', '//', '~/', {'ctype': ':', 'fallback': '/'})

inoremap <expr> = smartchr#loop('=', ' = ', ' == ')
inoremap <expr> ( smartchr#one_of('(', '()', "(\n)<C-o>O")
inoremap <expr> { smartchr#one_of('{', '{}', '{{{', "{\n}<C-o>O")
inoremap <expr> [ smartchr#one_of('[', '[]', "[\n]<C-o>O")
inoremap <expr> , smartchr#one_of(',', ', ')
" }}}

" Map: parenthesis {{{
" inoremap ( ()<Esc>i
" inoremap <expr> ) ClosePair(')')
" inoremap { {}<Esc>i
" inoremap <expr> } ClosePair('}')
" inoremap [ []<Esc>i
" inoremap <expr> ] ClosePair(']')

function! ClosePair(char) " {{{
	if getline('.')[col('.')-1] == a:char
		return "\<Right>"
	else
		return a:char
	endif
endfunction
" }}}
" }}}

" Map: neocomplcache {{{
nnoremap <Leader>ns :NecoSnip<Space>
nnoremap <Leader>nS :NecoRSnip<Space>
imap <C-l> <Plug>(neocomplcache_snippets_expand)
smap <C-l> <Plug>(neocomplcache_snippets_expand)
inoremap <expr> <C-g> neocomplcache#undo_completion()
" inoremap <expr> <C-l> neocomplcache#complete_common_string()
" inoremap <expr> <CR> neocomplcache#smart_close_popup() . "\<CR>"
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <C-h> neocomplcache#smart_close_popup() . "\<C-h>"
inoremap <expr> <C-h> neocomplcache#smart_close_popup() . "\<C-h>"
inoremap <expr> <C-y> pumvisible() ? neocomplcache#close_popup() : "\<C-y>"
inoremap <expr> <C-e> pumvisible() ? neocomplcache#cancel_popup() : "\<C-e>"
" }}}

" Map: alternative to nodoka {{{
function! Nodoka() " {{{
	noremap! <C-h> <Left>
	noremap! <C-j> <Down>
	noremap! <C-k> <Up>
	noremap! <C-l> <Right>

	noremap! <C-a> <Home>
	noremap! <C-e> <End>
	noremap! <C-@> <BS>

	noremap! <C-q>1 !
	noremap! <C-q>2 "
	noremap! <C-q>3 #
	noremap! <C-q>4 $
	noremap! <C-q>5 %
	noremap! <C-q>6 &
	noremap! <C-q>7 '
	noremap! <C-q>8 (
	noremap! <C-q>9 )
	noremap! <C-q>0 \|
endfunction

if !has('win32') && !has('win64')
	call Nodoka()
endif
" }}}
" }}}

" Augroup: {{{
augroup noname
	autocmd!
	autocmd BufNewFile,BufReadPost * setlocal ts=4 sw=4
	autocmd BufNewFile,BufReadPost *.rb setlocal ts=2 sw=2
	autocmd VimEnter * cmap <C-w> <M-BS>
	autocmd VimEnter *.snip setlocal filetype=snippet
	autocmd BufReadPost *
				\ if line("'\"") > 1 && line("'\"") <= line('$')
				\ | exe "normal! g`\""
				\ | endif
	autocmd BufReadPost ~/dev/linux-stable/*
				\ set path^=~/dev/linux-stable/include
augroup END
" }}}

" Augroup: filetype {{{
augroup filetype
	autocmd!
	autocmd FileType * setlocal formatoptions-=ro
	autocmd FileType vim
				\ if &buftype == 'nofile'
				\ | nnoremap <buffer> q <C-w>c
				\ | endif
	autocmd FileType help nnoremap <buffer> q <C-w>c
	autocmd FileType ref call s:init_vimref()
	autocmd FileType xml nnoremap <Leader>vxf :%!xmllint --format -<CR>
	autocmd FileType xml vnoremap <Leader>vxf :!xmllint --format -<CR>
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

" vim: ts=2 sw=2 fdm=marker:
