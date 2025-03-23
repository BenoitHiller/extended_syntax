# vim-gsed

Adds support for all of the GNU sed extensions to the included `syntax/sed.vim` syntax highlighting.

## Installation

With vim-plug

```vim
Plug 'BenoitHiller/vim-gsed'
```

This plugin should be compatible with both vim and neovim.

## Additions

* The commands `eFRTvWz`.
* Exit codes for `qQ`. Note: the Q command was already present.
* Support for the single line versions of `aci`.
* The additional `eMmi` flags for the `s` command. Note: the `Iw` flags were already present.

## Configuration

If you want to disable the extensions, like if you have autocmd rules to distinguish GNU sed files from other ones, you can assign the `g:sed_dialect` variable to any value besides `"gnu"`.

```vim
let g:sed_dialect = "default"
```

Note: the only other value with meaning currently is `"bsd"`, which in the base `syntax/sed.vim` adjusts the comment behaviour slightly. All other values give the default behaviour.
