" File:		vimfiles/plugin/textobj-fold.vim
" Author:	hirakaku <hirakaku@gmail.com>

" Level: 1 {{{
"	Level: 2 {{{
" Level: 3 {{{
"	for your test!
" }}}
" }}}
" }}}

if exists('g:textobj_fold_loaded')
	finish
endif

let g:textobj_fold_specs =
\	{
\		'-': {
\			'*sfile*'		: expand('<sfile>:p'),
\			'select-a'	: 'az',
\			'select-i'	: 'iz',
\			'*select-a-function*' : 's:select_fold_a',
\			'*select-i-function*' : 's:select_fold_i',
\		}
\	}

call textobj#user#plugin('fold', g:textobj_fold_specs)

function! s:select_fold_a() " {{{
	let level	= foldlevel(line('.'))
	let pos		= getpos('.')

	if level == 0 | return 0 | endif

	" D: get start position {{{
	normal! [z

	if foldlevel(line('.')) < level
		exe "normal! \<C-o>"
	endif

	let start = getpos('.')
	" }}}

	" D: get end position {{{
	normal! ]z

	if foldlevel(line('.')) < level
		exe "normal! \<C-o>"
	endif

	let end = getpos('.')
	" }}}
	
	call cursor(pos)

	return ['V', start, end]
endfunction

function! s:select_fold_i()
	return ['V', 0, 0]
endfunction " }}}

function! s:select_fold_i() " {{{
	let level	= foldlevel(line('.'))
	let pos		= getpos('.')

	if level == 0 | return 0 | endif

	" D: get start position {{{
	normal! [z

	if foldlevel(line('.')) < level
		exe "normal! \<C-o>"
	endif

	let start = getpos('.')
	" }}}

	" D: get end position {{{
	normal! ]z

	if foldlevel(line('.')) < level
		exe "normal! \<C-o>"
	endif

	let end = getpos('.')
	" }}}

	" D: narrowing {{{
	let start[1] += 1
	let end[1] -= 1

	if start[1] > end[1] | return 0 | endif
	" }}}

	call cursor(pos)

	return ['V', start, end]
endfunction " }}}

let g:textobj_fold_loaded = 1

" vim: ts=2 sw=2 ff=unix fdm=marker:
