
call plug#begin()
"f autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/vim-jsx-improve'
Plug 'clangd/coc-clangd'
Plug 'fannheyward/coc-marketplace'
"d
"f REPL tools
Plug 'jpalardy/vim-slime'
Plug 'klafyvel/vim-slime-cells'
"d
call plug#end()
"d

"f settings
"f set basic vim preferences
" basic vim settings
:set tabstop=4
:set shiftwidth=4
:set expandtab
:set nowrap
:set number
:set foldmethod=marker
:set foldmarker=f,d
autocmd FileType py setlocal foldmarker =#f,#d 
autocmd FileType vim setlocal foldmarker =\"f,\"d 
"d
"f slime settings (for REPLs)
let g:slime_target = 'tmux'
let g:slime_cell_delimiter = "^\\s*##"
let g:slime_no_mappings = 1
"d
"d
 
"f keybindings!
"f visual mode
vnoremap <Leader>' :<c-u>call SurroundWithFold()<CR>
function SurroundWithFold()
    let first_line = getline("'<")
    let first_line_whitespace = matchstr("^\s*a","   a")
    let foldDescription = input("Fold description! ")
    let [left_foldmarker, right_foldmarker] = split(&foldmarker, ',')
    call append(line("'<")-1, first_line_whitespace.left_foldmarker." ".foldDescription)
    call append(line("'>"), right_foldmarker)
    execute "normal! zc"
    "let words = @"
    "let words = left_foldmarker." ".foldDescription."\n".words.right_foldmarker."\n"
    "let @" = words
    ":normal! Pzc
endfunction
a"f fold
    "asdlfhalsdflasjdfhal
"d
    "asdlfhalsdflasjdfhal
    "lASKJfladsjflj
"d
"f slime
"\c send a cell!
nnoremap <Leader>c <Plug>SlimeCellsSend
"\v send a cell and jump to the next one!
nnoremap <Leader>v <Plug>SlimeCellsSendAndGoToNext
"\l launch ipython!
nnoremap <Leader>l :SlimeSend1 ipython --matplotlib --no-autoindent 
"\q send an exit command to anything we are running
nnoremap <Leader>q :SlimeSend1 exit 
"\p close all python plots
nnoremap <Leader>p :SlimeSend1 plt.close('all') 
"\a send the current line
nnoremap <Leader>a :SlimeSend
"d
"d


