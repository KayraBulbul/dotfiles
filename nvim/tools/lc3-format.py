#!/usr/bin/env python3
"""Align LC-3 fields without rewriting operands, strings, or comments."""
import re
import sys

OPS = set('ADD AND NOT LD LDI LDR LEA ST STI STR JMP JSR JSRR RET RTI TRAP GETC OUT PUTS IN PUTSP HALT NOP CHAT GETP SETP GETB SETB GETH REG .ORIG .END .FILL .BLKW .STRINGZ'.split())
OPS.update('BR' + suffix for suffix in ('', 'N', 'Z', 'P', 'NZ', 'NP', 'ZP', 'NZP'))


def format_line(line):
    text = line.rstrip('\r\n')
    if not text.strip():
        return ''
    if text.lstrip().startswith(';'):
        return text
    # Split only at semicolons outside quoted strings.
    quoted = escaped = False
    comment = ''
    for i, char in enumerate(text):
        if escaped:
            escaped = False
        elif char == '\\' and quoted:
            escaped = True
        elif char == '"':
            quoted = not quoted
        elif char == ';' and not quoted:
            text, comment = text[:i], text[i:]
            break
    fields = text.strip().split(None, 2)
    if not fields:
        return line.rstrip('\r\n')
    label = ''
    if fields[0].upper() not in OPS:
        label = fields.pop(0)
        if not fields or not re.fullmatch(r'[A-Za-z_][\w]*:?', label):
            return line.rstrip('\r\n')
        fields = ' '.join(fields).split(None, 1)
    else:
        fields = text.strip().split(None, 1)
    op = fields[0]
    if op.upper() not in OPS:
        return line.rstrip('\r\n')
    operands = fields[1] if len(fields) > 1 else ''
    prefix = '' if op.upper() in {'.ORIG', '.END'} and not label else label.ljust(12) + (' ' if len(label) >= 12 else '')
    result = prefix + (op.ljust(9) + operands if operands else op)
    return result + ('  ' + comment if comment else '')


if __name__ == '__main__':
    for line in sys.stdin:
        print(format_line(line))
