if exists('b:current_syntax')
  finish
endif
syn case ignore
syn keyword lc3Instruction ADD AND NOT LD LDI LDR LEA ST STI STR JMP JSR JSRR RET RTI TRAP NOP GETC OUT PUTS IN PUTSP HALT CHAT GETP SETP GETB SETB GETH REG
syn match lc3Instruction '\<BR[nzp]*\>'
syn match lc3Directive '\.\%(ORIG\|END\|FILL\|BLKW\|STRINGZ\)\>'
syn match lc3Register '\<R[0-7]\>'
syn match lc3Number '\<x[0-9a-f]\+\>\|#[-+]\?\d\+\|\<b[01]\+\>'
syn region lc3String start='"' skip='\\.' end='"'
syn match lc3Comment ';.*$' contains=@Spell
hi def link lc3Instruction Keyword
hi def link lc3Directive PreProc
hi def link lc3Register Identifier
hi def link lc3Number Number
hi def link lc3String String
hi def link lc3Comment Comment
let b:current_syntax = 'lc3'
