"f
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
:set tabstop=2
:set shiftwidth=2
:set expandtab
:set wrap
:set number
:set foldmethod=marker
:set foldmarker=//f,//d
autocmd FileType python setlocal foldmarker =#f,#d 
autocmd FileType vim setlocal foldmarker =\"f,\"d 
autocmd FileType sql setlocal foldmarker =--\ f,--\ d
au BufEnter,BufNew *.s setlocal foldmarker =;f,;d
"d
"f slime settings (for REPLs)
let g:slime_target = 'tmux'
let g:slime_cell_delimiter = "^.*##"
let g:slime_no_mappings = 1
"d
"d
 
"f keybindings!
"f visual mode
vnoremap <Leader>' :<c-u>call SurroundWithNamedFold()<CR>
vnoremap <Leader>; :<c-u>call SurroundWithUnnamedFold()<CR>
function SurroundWithNamedFold() "f
    "f aquire needed strings!
    let first_line_whitespace = matchstr(getline("'<"),"^\\s*")
    let foldDescription = input("Fold description! ")
    let [left_foldmarker, right_foldmarker] = split(&foldmarker, ',')
    "d
    "f add foldmarkers!
    call append(line("'<")-1, first_line_whitespace.left_foldmarker." ".foldDescription)
    call append(line("'>"), first_line_whitespace.right_foldmarker)
    "d
    "f refresh folds!
    execute "normal! zMzvzc"
    "d
endfunction "d
function SurroundWithUnnamedFold() "f
    "f make sure we have <2 lines!
    if getline("'<")==getline("'>")
        echo "Select at least two lines"
        return 0
    endif
    "d
    "f aquire needed strings!
    let first_line = getline("'<")
    let last_line = getline("'>")
    let [left_foldmarker, right_foldmarker] = split(&foldmarker, ',')
    "d
    "f add foldmarkers!
    call setline(line("'<"), first_line." ".left_foldmarker)
    call setline(line("'>"), last_line." ".right_foldmarker)
    "d
    "f refresh folds
    execute "normal! zMzvzc"
    "d
endfunction "d
"d
"f slime
"\c send a cell!
nnoremap <Leader>c <Plug>SlimeCellsSend
"\v send a cell and jump to the next one!
nnoremap <Leader>v <Plug>SlimeCellsSendAndGoToNext
"\l launch ipython!
nnoremap <Leader>l :SlimeSend1 ipython --matplotlib --no-autoindent<enter>
"\q send an exit command to anything we are running
nnoremap <Leader>q :SlimeSend1 exit<enter>
"\p close all python plots
nnoremap <Leader>p :SlimeSend1 plt.close('all')<enter>
"\a send the current line
nnoremap <Leader>v :SlimeSend<enter>
"d
"d

