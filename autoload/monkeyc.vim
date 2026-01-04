" Garmin Monkey C LSP configuration for Neovim
" Requires: Java runtime, Garmin Connect IQ SDK

if !has('nvim-0.11')
  finish
endif

let s:sdk_path = expand('~/.Garmin/ConnectIQ/Sdks')

function! s:find_latest_sdk() abort
  let l:sdks = glob(s:sdk_path . '/connectiq-sdk-*', 0, 1)
  if empty(l:sdks)
    return ''
  endif
  call sort(l:sdks)
  return l:sdks[-1]
endfunction

function! s:get_lsp_jar() abort
  let l:sdk = s:find_latest_sdk()
  if empty(l:sdk)
    return ''
  endif
  let l:jar = l:sdk . '/bin/LanguageServer.jar'
  if filereadable(l:jar)
    return l:jar
  endif
  return ''
endfunction

function! monkeyc#setup_lsp() abort
  let l:jar = s:get_lsp_jar()
  if empty(l:jar)
    echohl WarningMsg
    echom '[vim-monkeyc] Connect IQ SDK not found. LSP disabled.'
    echom '             Expected location: ' . s:sdk_path
    echohl None
    return
  endif

  if !executable('java')
    echohl WarningMsg
    echom '[vim-monkeyc] Java not found. LSP disabled.'
    echohl None
    return
  endif

  lua << EOF
  vim.lsp.config('monkeyc', {
    cmd = {
      'java',
      '-Dapple.awt.UIElement=true',
      '-classpath',
      vim.fn['s:get_lsp_jar'](),
      'com.garmin.monkeybrains.languageserver.LSLauncher',
    },
    filetypes = { 'monkeyc' },
    root_markers = { 'manifest.xml', 'monkey.jungle', '.git' },
  })
  vim.lsp.enable('monkeyc')
EOF
endfunction
