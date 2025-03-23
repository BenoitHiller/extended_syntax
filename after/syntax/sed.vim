" Vim syntax file
" Language: sed
" Maintainer: Benoit Hiller <benoit.hiller@gmail.com>
" URL: https://github.com/BenoitHiller/vim-gsed
" Last Change: 2025 March 23

" This file depends on and modifies the included vim sed syntax highlighting

" because this is just for the GNU sed we don't want to do anything if the
" user has explicitly said they are using a different dialect.
if exists("g:sed_dialect") && g:sed_dialect !=? "gnu"
  finish
endif

" add extended functions
syn match sedFunction "[ezF]\s*\($\|;\)" contains=sedSemicolon,sedWhitespace
" add end of line comment support for the new functions
syn match sedFunction "[ezF]\s*\ze#"

" add extended regex flags
syn match sedFlag "[[:digit:]geiMmpI]*w\=" contains=sedFlagwrite contained
" I do not understand why this cluster is normally empty there doesn't seem to
" be any code to ever set it, but it is used
syn cluster sedFlags add=sedFlag

" add nice highlighting to valid exit codes in the q and Q commands
syn match sedExitCode "[0-9]\+" contained nextgroup=sedSemicolon,sedWhitespace
syn match sedInvalidExitCode "[0-9]\{4,}\|[^0-9]\+\|25[6-9]\|2[6-9][0-9]\|[3-9][0-9][0-9]\|0[0-9]\+" contained nextgroup=sedSemicolon,sedWhitespace

" add support for the new functions which have arguments
syn region sedQ matchGroup=sedFunction start="[qQ]" matchgroup=sedSemicolon end=";\|$\|\ze#.*$" contains=sedExitCode,sedInvalidExitCode,sedSemicolon,sedWhitespace
syn region sedBranch matchgroup=sedFunction start="[btT]" matchgroup=sedSemicolon end=";\|$\|\ze#.*$" contains=sedWhitespace
syn region sedRW matchgroup=sedFunction start="[lRWv]" matchgroup=sedSemicolon end=";\|$\|\ze#.*$" contains=sedWhitespace

" extend aci, and add e, such that they can get input on the same line
syn region sedACIE matchgroup=sedFunction start="[aci]" matchgroup=NONE end="[^\\]$\|^$" contains=sedLineCont,sedTab
syn match sedEmptyACI "[aci]\s*$" contains=sedWhitespace

" e is the only one of these multiline commands that is allowed to be empty.
" It is also new because it is a GNU extension.
syn region sedE matchgroup=sedFunction start="[e]" matchgroup=NONE skip="\\$" end="$" contains=sedLineCont,sedTab

hi link sedExitCode Constant
hi link sedEmptyACI Error
hi link sedInvalidExitCode Error

" vim: nowrap sw=2 sts=2 ts=8 noet:
