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
    call cursor(-1, -1)
    if a:mode == 'v'
        normal! `z
    endif
    let here = '.'
    normal! m`
    let col = col(here)
    let line = line(here)
    let sign = 1
    let flags = ''
    if a:dir == 'b'
        let sign = -1
        let flags = 'b'
    endif
    for _ in range(a:range)
        if s:isEmptyBlockLine(line(here), col)
            call search(s:nonEmptyPattern(col), flags)
            call cursor(line(here), col)
        elseif s:isStopperLine(line(here) + (1 * sign), col)
            call cursor(line(here) + (1 * sign), col)
            call search(s:nonStopperPattern(col), flags)
            call cursor(line(here), col)
        else
            call search(s:stopperPattern(col) . '\|^$', flags)
            call cursor(line(here) - (1 * sign), col)
        endif
    endfor
    if line(here) > line && a:dir == 'b'
        normal! gg
        call cursor(line(here), col)
    elseif line(here) < line && a:dir != 'b'
        normal! G
        call cursor(line(here), col)
    endif
    if a:mode == 'v' || a:mode == 'V' || a:mode == ''
        normal! mzgv`z
    endif
endfunction

command! -range -nargs=1 Vertical call Vertical('n', <f-args>, (<line2> - <line1> + 1))
