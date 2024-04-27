"  plugins
"   install plugin manager!
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" 
"   install plugins!
call plug#begin()
"   COC
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/vim-jsx-improve'
Plug 'clangd/coc-clangd'
Plug 'fannheyward/coc-marketplace'
" 
"   slime
Plug 'jpalardy/vim-slime'
Plug 'klafyvel/vim-slime-cells'
" 
call plug#end()
" 
" 
"  basic preferences
:set tabstop=4
:set shiftwidth=4
:set expandtab
:set wrap
:set number
:set foldmethod=marker
:set list
" 
"  fold stuff!
"  foldmarkers!
:set foldmarker=//  , 
autocmd filetype python setlocal foldmarker =#  ,# 
autocmd filetype r setlocal foldmarker =#f,#d 
autocmd filetype vim setlocal foldmarker =\"  ,\" 
autocmd filetype sql setlocal foldmarker =--\ f,--\ d
au BufEnter,BufNew *.s setlocal foldmarker =;f,;d
" 
"  hotkeys!
vnoremap <Leader>' :<c-u>call SurroundWithNamedFold()<CR>
vnoremap <Leader>; :<c-u>call SurroundWithUnnamedFold()<CR>
" 
"  pretty fold text
let fold_text_discriminator="@@@@"
:set foldtext=CustomFoldText()
" 
"  functions!
function SurroundWithNamedFold() "  
    "   aquire needed strings!
    let first_line_whitespace = matchstr(getline("'<"),"^\\s*")
    let foldDescription = input("Fold description! ")
    let [left_foldmarker, right_foldmarker] = split(&foldmarker, ',')
    " 
    "   add foldmarkers!
    call append(line("'<")-1, first_line_whitespace.left_foldmarker."".foldDescription)
    call append(line("'>"), first_line_whitespace.right_foldmarker)
    " 
    "   refresh folds!
    execute "normal! zMzvzc"
    " 
endfunction " 
function SurroundWithUnnamedFold() "  
    "   make sure we have <2 lines!
    "if getline("'<")==getline("'>")
    "   echo "Select at least two lines"
    "   return 0
    "endif
    " 
    "   aquire needed strings!
    let first_line = getline("'<")
    let first_line_whitespace = matchstr(getline("'<"),"^\\s*")
    let [left_foldmarker, right_foldmarker] = split(&foldmarker, ',')
    " 
    "   add foldmarkers!
    call setline(line("'<"), first_line." ".left_foldmarker)
    call append(line("'>"), first_line_whitespace.right_foldmarker)
    " 
    "   refresh folds
    execute "normal! zMzvzc"
    " 
endfunction " 
function CustomFoldText() "  
    let display_line_number=v:foldstart
    let display_line=getline(display_line_number)
    let ick_found=(-1!=match(display_line, g:fold_text_discriminator))
    while ick_found
        let display_line_number=display_line_number + 1
        let display_line=getline(display_line_number)
        let ick_found=(-1!=match(display_line, g:fold_text_discriminator))
    endwhile
    return matchstr(foldtext(), "^.*:").display_line
    "if ick_found
    "    let return_value="ick: ".display_line
    "else
    "    let return_value="good: ".display_line
    "endif
    "return return_value
endfunction
" 
" 
" 
"  slime!
"  hotkeys!
"   <Leader>c send a cell!
"This needs the execute to work on some platforms?
nnoremap <Leader>c :execute "normal \<Plug>SlimeCellsSend"<enter><enter>
" 
"   <Leader>v send a cell and jump to the next one!
"This needs the execute to work on some platforms?
nnoremap <Leader>v :execute "normal \<Plug>SlimeCellsSendAndGoToNext"<enter><enter>
" 
"   <Leader>a send the current line
nnoremap <Leader>a :SlimeSend<enter>
" 
"   <Leader>l launch repl!
nnoremap <Leader>l :execute ":SlimeSend1 " . repl_launch_command<enter>
" 
"   <Leader>q send exit command!
nnoremap <Leader>q :execute ":SlimeSend1 " . repl_exit_command<enter><enter>
" 
"   <Leader>p send utility command!
nnoremap <Leader>p :execute ":SlimeSend1 " . repl_utility_command<enter><enter>
" 
"   <Leader>s send user specified command!
nnoremap <Leader>s :SlimeSend1 
" 
"   <Leader>: make cell boundary!
nnoremap <Leader>: :execute "normal O" . g:slime_cell_delimiter . " "<enter>j0
" 
" 
"   general settings
let g:slime_target = 'tmux'
let g:slime_no_mappings = 1
" 
"   language utilities!
"   python
autocmd filetype python let repl_launch_command="ipython --matplotlib --no-autoindent" 
autocmd filetype python let repl_exit_command="exit()" 
autocmd filetype python let repl_utility_command="plt.close(\"all\")" 
autocmd filetype python let g:slime_cell_delimiter="###"
" 
"   r
autocmd filetype r let repl_launch_command="R" 
autocmd filetype r let repl_exit_command="q(\"no\")" 
autocmd filetype r let repl_utility_command="# Utility command not configured" 
autocmd filetype r let g:slime_cell_delimiter="###"
" 
"   unrecognized files
let repl_launch_command="no launch command set for this filetype" 
let repl_exit_command="no exit command set for this filetype" 
let repl_utility_command="no utility command set for this filetype" 
let g:slime_cell_delimiter="cell delimiter not set"
" 
" 
" 
"  make space a leader!
nmap <Space> <Leader>
vmap <Space> <Leader>
" 
