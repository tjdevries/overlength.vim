let overlength#default_to_textwidth = get(g:, 'overlength#default_to_textwidth', 1)
let overlength#default_overlength = get(g:, 'overlength#default_overlength', 80)

highlight! OverLength ctermbg=darkgrey guibg=#8b0000

augroup overlength_autocmds
    au!
    autocmd BufEnter * call overlength#highlight()
augroup END
