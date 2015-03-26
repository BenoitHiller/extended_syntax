" Vim syntax file
" Language:	sed
" Maintainer:	Benoit Hiller <benoit.hiller@gmail.com>
" URL:		https://github.com/StephenHamilton/extended_syntax
" Last Change:	2015 March 26
" Notes:        This file is derived from the original included with vim,
"               which is maintained by Haakon Riiser <hakonrk@fys.uio.no>.

if version < 600
    syn clear
elseif exists("b:current_syntax")
    finish
endif

syn match sedError "\S"

syn match sedWhitespace "\s\+" contained
syn match sedSemicolon ";"
syn match sedAddress "[[:digit:]$]"
syn match sedAddress "\d\+\~\d\+"
syn match sedCode "25[0-5]\|2[0-4][0-9]\|1[0-9][0-9]\|[1-9]\?[0-9]" contained nextgroup=sedSemicolon
syn region sedAddress matchgroup=Special start="[{,;]\s*/\(\\/\)\="lc=1 skip="[^\\]\(\\\\\)*\\/" end="/I\=" contains=sedTab,sedRegexpMeta
syn region sedAddress matchgroup=Special start="^\s*/\(\\/\)\=" skip="[^\\]\(\\\\\)*\\/" end="/I\=" contains=sedTab,sedRegexpMeta
syn match sedComment "^\s*#.*$"
syn match sedFunction "[dDgGhHlnNpPx=zFL]\s*\($\|;\)" contains=sedSemicolon,sedWhitespace

syn region sedErrorCode matchgroup=sedFunction start="[qQ]" matchgroup=sedSemicolon end=";\|$" contains=sedWhitespace,sedSemicolon,sedError
syn match sedFunction "[qQ]\s*[[:digit:]]*\s*\($\|;\)" contains=sedCode,sedWhitespace,sedSemicolon

syn match sedLabel ":[^;]*"
syn match sedLineCont "^\(\\\\\)*\\$" contained
syn match sedLineCont "[^\\]\(\\\\\)*\\$"ms=e contained
syn match sedSpecial "[{},!]"
if exists("highlight_sedtabs")
    syn match sedTab "\t" contained
endif

" Append/Change/Insert
syn region sedACI matchgroup=sedFunction start="[acei]" matchgroup=NONE end="[^\\]$\|^$" contains=sedLineCont,sedTab
syn match sedEmptyACI "[aci]\s*$" contains=sedWhitespace
syn match sedFunction "e\s*$" contains=sedWhitespace

syn region sedBranch matchgroup=sedFunction start="[btT]" matchgroup=sedSemicolon end=";\|$" contains=sedWhitespace
syn region sedRW matchgroup=sedFunction start="[lLrRwWv]" matchgroup=sedSemicolon end=";\|$" contains=sedWhitespace

" Substitution/transform with various delimiters
syn region sedFlagwrite matchgroup=sedFlag start="w" matchgroup=sedSemicolon end=";\|$" contains=sedWhitespace contained
syn match sedFlag "[[:digit:]geiMmpI]*w\=" contains=sedFlagwrite contained
syn match sedRegexpMeta "[.*^$]" contained
syn match sedRegexpMeta "\\." contains=sedTab contained
syn match sedRegexpMeta "\[.\{-}\]" contains=sedTab contained
syn match sedRegexpMeta "\\{\d\*,\d*\\}" contained
syn match sedRegexpMeta "\\(.\{-}\\)" contains=sedTab contained
syn match sedReplaceMeta "&\|\\\($\|.\)" contains=sedTab contained

" Metacharacters: $ * . \ ^ [ ~
" @ is used as delimiter and treated on its own below
let __at = char2nr("@")
let __sed_i = char2nr(" ") " ASCII: 32, EBCDIC: 64
if has("ebcdic")
    let __sed_last = 255
else
    let __sed_last = 126
endif
let __sed_metacharacters = '$*.\^[~'
while __sed_i <= __sed_last
    let __sed_delimiter = escape(nr2char(__sed_i), __sed_metacharacters)
    if __sed_i != __at
        exe 'syn region sedAddress matchgroup=Special start=@\\'.__sed_delimiter.'\(\\'.__sed_delimiter.'\)\=@ skip=@[^\\]\(\\\\\)*\\'.__sed_delimiter.'@ end=@'.__sed_delimiter.'I\=@ contains=sedTab'
        exe 'syn region sedRegexp'.__sed_i  'matchgroup=Special start=@'.__sed_delimiter.'\(\\\\\|\\'.__sed_delimiter.'\)*@ skip=@[^\\'.__sed_delimiter.']\(\\\\\)*\\'.__sed_delimiter.'@ end=@'.__sed_delimiter.'@me=e-1 contains=sedTab,sedRegexpMeta keepend contained nextgroup=sedReplacement'.__sed_i
        exe 'syn region sedReplacement'.__sed_i 'matchgroup=Special start=@'.__sed_delimiter.'\(\\\\\|\\'.__sed_delimiter.'\)*@ skip=@[^\\'.__sed_delimiter.']\(\\\\\)*\\'.__sed_delimiter.'@ end=@'.__sed_delimiter.'@ contains=sedTab,sedReplaceMeta keepend contained nextgroup=sedFlag'
    endif
    let __sed_i = __sed_i + 1
endwhile
syn region sedAddress matchgroup=Special start=+\\@\(\\@\)\=+ skip=+[^\\]\(\\\\\)*\\@+ end=+@I\=+ contains=sedTab,sedRegexpMeta
syn region sedRegexp64 matchgroup=Special start=+@\(\\\\\|\\@\)*+ skip=+[^\\@]\(\\\\\)*\\@+ end=+@+me=e-1 contains=sedTab,sedRegexpMeta keepend contained nextgroup=sedReplacement64
syn region sedReplacement64 matchgroup=Special start=+@\(\\\\\|\\@\)*+ skip=+[^\\@]\(\\\\\)*\\@+ end=+@+ contains=sedTab,sedReplaceMeta keepend contained nextgroup=sedFlag

" Since the syntax for the substituion command is very similar to the
" syntax for the transform command, I use the same pattern matching
" for both commands.  There is one problem -- the transform command
" (y) does not allow any flags.  To save memory, I ignore this problem.
syn match sedST	"[sy]" nextgroup=sedRegexp\d\+

if version >= 508 || !exists("did_sed_syntax_inits")
    if version < 508
        let did_sed_syntax_inits = 1
        command -nargs=+ HiLink hi link <args>
    else
        command -nargs=+ HiLink hi def link <args>
    endif

    HiLink sedAddress Macro
    HiLink sedACI NONE
    HiLink sedBranch Label
    HiLink sedComment Comment
    HiLink sedDelete Function
    HiLink sedError Error
    HiLink sedEmptyACI Error
    HiLink sedErrorCode Error
    HiLink sedFlag Type
    HiLink sedFlagwrite Constant
    HiLink sedCode Constant
    HiLink sedFunction Function
    HiLink sedLabel Label
    HiLink sedLineCont Special
    HiLink sedPutHoldspc Function
    HiLink sedReplaceMeta Special
    HiLink sedRegexpMeta Special
    HiLink sedRW Constant
    HiLink sedSemicolon Special
    HiLink sedST Function
    HiLink sedSpecial Special
    HiLink sedWhitespace NONE
    if exists("highlight_sedtabs")
        HiLink sedTab Todo
    endif
    let __sed_i = char2nr(" ") " ASCII: 32, EBCDIC: 64
    while __sed_i <= __sed_last
        exe "HiLink sedRegexp".__sed_i "Macro"
        exe "HiLink sedReplacement".__sed_i "NONE"
        let __sed_i = __sed_i + 1
    endwhile

    delcommand HiLink
endif

unlet __sed_i __sed_last __sed_delimiter __sed_metacharacters

let b:current_syntax = "sed"

" vim: sts=4 sw=4 ts=8 et
