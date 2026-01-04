" vim-monkeyc: Syntax highlighting and LSP support for Garmin Monkey C

if exists('g:loaded_monkeyc')
  finish
endif
let g:loaded_monkeyc = 1

let g:monkeyc_lsp_enabled = get(g:, 'monkeyc_lsp_enabled', 1)

if has('nvim-0.11') && g:monkeyc_lsp_enabled
  augroup monkeyc_lsp
    autocmd!
    autocmd FileType monkeyc call monkeyc#setup_lsp()
  augroup END
endif
