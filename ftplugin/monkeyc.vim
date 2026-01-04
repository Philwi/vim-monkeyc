" Filetype plugin for Garmin Monkey C
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal commentstring=//\ %s
setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://!,://
setlocal suffixesadd=.mc
setlocal includeexpr=substitute(v:fname,'\\.','/','g')

setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab

let b:undo_ftplugin = "setlocal commentstring< comments< suffixesadd< includeexpr< tabstop< shiftwidth< expandtab<"
