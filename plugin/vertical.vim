function! s:emptyStartPattern(col)
    return '^\s\{' . a:col . '\}'
endfunction

function! s:emptyBlockPattern(col)
    return '^.\{' . (a:col - 3) . ',' . (a:col - 1) . '\}\s\{3\}'
endfunction

function! s:emptyPattern(col)
    return s:emptyStartPattern(a:col) . '\|' . s:emptyBlockPattern(a:col)
endfunction

function! s:shorterLinePattern(col)
    return '^.\{,' . (a:col - 1) . '\}$'
endfunction

function! s:stopperPattern(col)
    return s:emptyPattern(a:col) . '\|' . s:shorterLinePattern(a:col)
endfunction

function! s:nonEmptyPattern(col)
    return '\(' . s:inversePattern(s:emptyPattern(a:col)) . '\)\(^$\)\@!'
endfunction

function! s:nonStopperPattern(col)
    return '\(' . s:inversePattern(s:stopperPattern(a:col)) . '\)\(^$\)\@!'
endfunction

function! s:inversePattern(pattern)
    return '^\(\(' . a:pattern . '\)\@!.\)*$'
endfunction

function! s:matchLine(line, pattern)
    return match(getline(a:line), a:pattern) != -1
endfunction

function! s:isEmptyBlockLine(line, col)
    return s:matchLine(a:line, s:emptyPattern(a:col) . '\|^$')
endfunction

function! s:isStopperLine(line, col)
    return s:matchLine(a:line, s:stopperPattern(a:col) . '\|^$')
endfunction

function! Vertical(mode, dir, range)
    normal! m`
    for _ in range(a:range)
        let col = col('.')
        let line = line('.')
        let sign = 1
        let flags = ''
        if a:dir == 'b'
            let sign = -1
            let flags = 'b'
        endif
        if s:isEmptyBlockLine(line('.'), col)
            call search(s:nonEmptyPattern(col), flags)
            call cursor(line('.'), col)
        elseif s:isStopperLine(line('.') + (1 * sign), col)
            call cursor(line('.') + (1 * sign), col)
            call search(s:nonStopperPattern(col), flags)
            call cursor(line('.'), col)
        else
            call search(s:stopperPattern(col) . '\|^$', flags)
            call cursor(line('.') - (1 * sign), col)
        endif
        if line('.') > line && a:dir == 'b'
            normal! gg
            call cursor(line('.'), col)
        elseif line('.') < line && a:dir != 'b'
            normal! G
            call cursor(line('.'), col)
        endif
        if a:mode == 'v' || a:mode == 'V' || a:mode == ''
            normal! mzgv`z
        endif
    endfor
endfunction

command! -range -nargs=1 Vertical call Vertical('n', <f-args>, (<line2> - <line1> + 1))
