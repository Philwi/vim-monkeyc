" Vim syntax file for Garmin Monkey C (.mc files)
" Language:    Monkey C (Garmin Connect IQ)
" Maintainer:  philwi
" URL:         https://github.com/philwi/vim-monkeyc
" License:     MIT

if exists("b:current_syntax")
  finish
endif

syn case match
syn sync fromstart

" Comments - highest priority, must come first
syn region mcBlockComment start="/\*" end="\*/" contains=mcTodo
syn match mcDocComment "//!.*$"
syn match mcLineComment "//[^!].*$"
syn match mcLineComment "//\s*$"
syn keyword mcTodo contained TODO FIXME XXX NOTE HACK BUG WARN WARNING DEPRECATED

" Strings and characters
syn region mcString start=+"+ skip=+\\"+ end=+"+ contains=mcEscape,mcStringInterp
syn region mcChar start=+'+ skip=+\\'+ end=+'+
syn match mcEscape contained "\\[nrtfb\\\"']"
syn match mcEscape contained "\\x[0-9a-fA-F]\{2}"
syn match mcEscape contained "\\u[0-9a-fA-F]\{4}"

" Garmin-specific annotations (:annotation) or (:annotation=value)
syn match mcAnnotation "(:[^)]*)"

" Numbers
syn match mcNumber "\<\d\+\>"
syn match mcNumber "\<0x[0-9a-fA-F]\+\>"
syn match mcNumber "\<0b[01]\+\>"
syn match mcNumber "\<\d\+\.\d*\%([eE][+-]\?\d\+\)\?\>"
syn match mcNumber "\<\d\+[lLfFdD]\>"

" Language keywords
syn keyword mcKeyword class function var const enum module extends using as
syn keyword mcKeyword if else switch case default for while do break continue return
syn keyword mcKeyword try catch finally throw new instanceof
syn keyword mcKeyword public private protected static hidden weak
syn keyword mcKeyword self me rez and or not has

" Primitive types
syn keyword mcType Void Boolean Number Float Double Long String Symbol
syn keyword mcType Array Dictionary Object Char Method WeakReference

" Toybox modules and common classes
syn keyword mcModule Lang Toybox System Application Graphics WatchUi Timer
syn keyword mcModule Sensor Activity Position Attention Communications
syn keyword mcModule Background Complications Cryptography FitContributor
syn keyword mcModule Math Media PersistedContent PersistedLocations
syn keyword mcModule SensorHistory StringUtil Test Time UserProfile Weather

" Common classes
syn keyword mcClass Dc View BehaviorDelegate Menu MenuItem InputDelegate
syn keyword mcClass ActivityRecording BluetoothLowEnergy AntPlus

" Constants
syn keyword mcConstant true false null

" Operators - exclude / when followed by / or * (comments)
syn match mcOperator "[+\-*%=<>!&|^~?:]"
syn match mcOperator "/\%([/*]\)\@!"
syn match mcOperator "\<instanceof\>"

" Delimiters
syn match mcDelimiter "[{}()\[\];,.]"

" Function calls (identifier followed by parenthesis)
syn match mcFunctionCall "\<\w\+\s*(" contains=mcDelimiter

" Highlighting links
hi def link mcBlockComment Comment
hi def link mcDocComment SpecialComment
hi def link mcLineComment Comment
hi def link mcTodo Todo
hi def link mcString String
hi def link mcChar Character
hi def link mcEscape SpecialChar
hi def link mcStringInterp Special
hi def link mcAnnotation PreProc
hi def link mcNumber Number
hi def link mcKeyword Keyword
hi def link mcType Type
hi def link mcModule Structure
hi def link mcClass Type
hi def link mcConstant Constant
hi def link mcOperator Operator
hi def link mcDelimiter Delimiter
hi def link mcFunctionCall Function

let b:current_syntax = "monkeyc"
