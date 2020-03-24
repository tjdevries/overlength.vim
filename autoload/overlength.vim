highlight! OverLength ctermbg=darkgrey guibg=#8b0000

let s:highlight_overlength = v:true

function! overlength#enable() abort
  let s:highlight_overlength = v:true

  call overlength#highlight()
endfunction

function! overlength#disable() abort
  let s:highlight_overlength = v:false

  call overlength#clear()
endfunction

let s:overlength_filetype_specific_lengths = {}
function! overlength#set_overlength(filetype, length)
  let s:overlength_filetype_specific_lengths[a:filetype] = a:length

  call overlength#highlight()
endfunction

function! s:get_default_to_tw() abort
  return get(g:, 'overlength#default_to_textwidth', 1)
endfunction

function! s:get_repeat_char() abort
  return get(g:, 'overlength#highlight_to_end_of_line', v:true) ? '.*' : ''
endfunction

function! s:get_virtual_column_modifier() abort
  return get(g:, 'overlength#highlight_to_end_of_line', v:true) ? '>' : ''
endfunction

function! s:get_virtual_column_offset() abort
 return get(g:, 'overlength#highlight_to_end_of_line', v:true) ? -1 : 0
endfunction

function! s:get_default_length() abort
  return get(g:, 'overlength#default_overlength', 80)
endfunction

function! overlength#get_overlength()
  if has_key(s:overlength_filetype_specific_lengths, &filetype)
    return s:overlength_filetype_specific_lengths[&filetype]
  endif

  " Different options based on default_to_textwidth
  " `0`: Don't use `&textwidth` at all.
  "     Always use `overlength#default_overlength`.
  " `1`: Use `&textwidth`, unless it's 0,
  "     then use `overlength#default_overlength`.
  " `2`: Always use `&textwidth`. There will be no highlighting where
  "     `&textwidth == 0`, unless added explicitly
  "
  " If &textwidth == 0, we just won't highlight in that filetype, that's
  " handled later though
  let default_to_textwidth = s:get_default_to_tw()
  let default_length = s:get_default_length()

  return default_to_textwidth > 0 ?
        \ ( (default_to_textwidth == 1 && (&textwidth > 0)
            \ || default_to_textwidth == 2) ?
              \ &textwidth
              \ : default_length)
        \ : default_length
endfunction

function! overlength#set_highlight(cterm, guibg)
  call execute(printf('highlight OverLength ctermbg=%s guibg=%s', a:cterm, a:guibg))
endfunction

function! overlength#clear() abort
  if exists('w:last_overlength')
    " Just try and delete it
    " Don't worry if it messes up
    silent! call matchdelete(w:last_overlength)
    silent! unlet w:last_overlength
  endif
endfunction

function! overlength#toggle() abort
  let s:highlight_overlength = !s:highlight_overlength

  if s:highlight_overlength
    call overlength#highlight()
  else
    call overlength#clear()
  endif
endfunction

function! overlength#highlight() abort
  call overlength#clear()

  if overlength#get_overlength() == 0
    return
  endif

  if s:highlight_overlength
    if !exists('w:last_overlength')
      let w:overlength_pattern = '\%' .
            \ s:get_virtual_column_modifier() .
            \ (overlength#get_overlength()
              \ + g:overlength#default_grace_length
              \ + s:get_virtual_column_offset())
            \ . 'v' . s:get_repeat_char()

      let w:last_overlength = matchadd('OverLength', w:overlength_pattern)
    endif
  endif
endfunction

