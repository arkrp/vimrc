"f plugins
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
"f configure basic preferences 
:set tabstop=4
:set shiftwidth=4
:set expandtab
:set wrap
:set number
:set foldmethod=marker
:set foldmarker=//f,//d
"d
"f configure language preferences!
"f set foldmarkers!
autocmd filetype python setlocal foldmarker =#f,#d 
autocmd filetype r setlocal foldmarker =#f,#d 
autocmd filetype vim setlocal foldmarker =\"f,\"d 
autocmd filetype sql setlocal foldmarker =--\ f,--\ d
au BufEnter,BufNew *.s setlocal foldmarker =;f,;d
"d
"f set REPL commands!
" this sets the proper REPL command for the language in question. Different
" languages require different programs and options to run
"f python
autocmd filetype python let repl_launch_command="ipython --matplotlib --no-autoindent" 
autocmd filetype python let repl_exit_command="exit()" 
autocmd filetype python let repl_utility_command="plt.close(\"all\")" 
"d
"f r
autocmd filetype r let repl_launch_command="R" 
autocmd filetype r let repl_exit_command="q(\"no\")" 
autocmd filetype r let repl_utility_command="# Utility command not configured" 
"d
"d
"d
"f slime settings (for REPLs)
let g:slime_target = 'tmux'
let g:slime_cell_delimiter = "^.*##"
let g:slime_no_mappings = 1
"d
"d
"f keybindings!
"f make space a leader!
nmap <Space> <Leader>
vmap <Space> <Leader>
"d
"f visual mode
"f bind hotkeys!
vnoremap <Leader>' :<c-u>call SurroundWithNamedFold()<CR>
vnoremap <Leader>; :<c-u>call SurroundWithUnnamedFold()<CR>
"d
"f make visual mode functions
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
"d
"f slime
"f \c send a cell!
"This needs the execute to work on some platforms?
nnoremap <Leader>c :execute "normal \<Plug>SlimeCellsSend"
"d
"f \v send a cell and jump to the next one!
"This needs the execute to work on some platforms?
nnoremap <Leader>v :execute "normal \<Plug>SlimeCellsSendAndGoToNext"
"d
"f \a send the current line
nnoremap <Leader>a :SlimeSend<enter>
"d
"f \l launch repl!
nnoremap <Leader>l :execute ":SlimeSend1 " . repl_launch_command<enter>
"d
"f \q send exit command!
nnoremap <Leader>q :execute ":SlimeSend1 " . repl_exit_command<enter><enter>
"d
"f \p send utility command!
nnoremap <Leader>p :execute ":SlimeSend1 " . repl_utility_command<enter><enter>
"d
"f \s send user specified command!
nnoremap <Leader>s :SlimeSend1 
"d
"d
"d
