" Ivan Sichmann Freitas <ivansichfreitas (_at_) gmail (_dot_) com>

set nocompatible  " VIM POWER!!!!
set encoding=utf8

" C highlighting
hi DefinedByUser ctermfg=lightgrey guifg=blue
hi cBraces ctermfg=lightgreen guifg=lightgreen
hi link cUserFunction DefinedByUser
hi link cUserFunctionPointer DefinedByUser

" C syntax options (see :help c.vim)
let c_syntax_for_h    = 0 " use c syntax to .h files instead of c++ syntax
let c_space_errors    = 0 " trailing whitespave or spaces before tabs
let c_comment_strings = 0 " highligh numbers and strings insede comments
let c_no_comment_fold = 1 " disable syntax based folding for comments
let c_gnu             = 1 " highlight gnu extensions
let c_minlines        = 100

" Doxygen syntax
let g:load_doxygen_syntax=1

" python indenting options (see :help ft-python-indent)
let g:pyindent_open_paren   = '&sw'
let g:pyindent_nested_paren = '&sw'
let g:pyindent_continue     = '&sw *2'

" python syntax
let g:python_highlight_all   = 1
let python_print_as_function = 1

" vhdl syntax configuration
let g:vhdl_indent_genportmap = 0
let g:vhdl_indent_rhsassign = 1

" pylint configuration
let g:pylint_onwrite = 0
let g:pylint_cwindow = 0

" eclim configuration
let g:EclimPythonValidate = 0
let g:EclimCValidate      = 0
let g:EclimDisabled       = 1

" haskell syntax highlighting configuration
let hs_highlight_types      = 1
let hs_highlight_more_types = 1
let hs_highlight_boolean    = 1

" Tagbar configurations
let g:tagbar_left = 1

" TaskList configuration
let g:tlTokenList = ['TODO', 'FIXME', 'NOTE', 'HACK']

" Variable settings for SingleCompile
let g:SingleCompile_usedialog   = 0
let g:SingleCompile_usequickfix = 1
" Setting the compiler options in SingleCompiler
call SingleCompile#SetCompilerTemplate('c', 'gcc', 'GNU C Compiler', 'gcc', '-Wall -Wextra -std=c99 -pedantic -ggdb3 -lm -o "%<"', './"%<"')
call SingleCompile#SetCompilerTemplate('c++', 'g++', 'GNU C++ Compiler', 'g++', '-Wall -Wextra -pedantic -ggdb3 -lm -o "%<"', './"%<"')
call SingleCompile#SetCompilerTemplate('python', 'python', 'Python Interpreter', 'python', '', '')
" Setting the default compilers
call SingleCompile#ChooseCompiler('c', 'gcc')
call SingleCompile#ChooseCompiler('c++', 'g++')
call SingleCompile#ChooseCompiler('python', 'python')

" Defines line limit for yaifa scanning
let yaifa_max_lines = 1024

" omnicppcomplete options
let OmniCpp_GlobalScopeSearch   = 1 " searches in the global scope
let OmniCpp_NamespaceSearch     = 2 " search in included files also
let OmniCpp_DisplayMode         = 1 " always show all class members
let OmniCpp_ShowScopeInAbbr     = 0 " don't show scope in abbreviations
let OmniCpp_ShowPrototypeInAbbr = 1 " display prototype in abbreviations
let OmniCpp_ShowAccess          = 1 " show access
let OmniCpp_MayCompleteDot      = 1 " automatically completes after a '.'
let OmniCpp_MayCompleteArrow    = 1 " automatically completes after a '->'
let OmniCpp_MayCompleteScope    = 1 " automatically completes afer a '::'
let OmniCpp_SelectFirstItem     = 0 " don't select the first match in the popup menu

" tex support
let g:tex_flavor="pdflatex"

set synmaxcol=200
set showmatch     " Show matching brackets (briefly jump to it)
set splitright
set nosplitbelow
set magic
set backspace=indent,eol,start

" Backup and history options
set backupdir+=~/.vim/backup " Put backup files (annoying ~ files) in another directory
set history=1000             " Increase history size
set ul=1000                  " Max undo levels
set background=dark          " Set best color scheme to dark consoles
set autoread                 " automagically reloads a file if it was externally modified
set textwidth=80              " don't break long lines
set colorcolumn=85
set formatoptions=qrn1

" list chars
set list
set listchars=tab:▸\ ,

" Appearance
set title    " Change the terminal title
set modelines=0
set ttyfast  " Smooth editing
set showmode
set number
set hidden
set wrap   " don't visually breaks long lines
if has("gui_running")
    set guioptions=agit " setting a less cluttered gvim
    set t_Co=256        " setting the number of colors
    " installed colorschemes: darkspectrum,liquidcarbon,molokai,wombat,sonofobsidias
    colorscheme wombat
endif

" Indentation
set shiftwidth=4
set tabstop=4     " tabstop == ts
set softtabstop=4
set shiftround
set expandtab

" Searching
set hlsearch   " highlight search results
set incsearch  " incremental search
set ignorecase
set smartcase
set gdefault " use global as default in substitutions

" Better completion menu
set wildmenu
set wildmode=longest,full
set wildignore+=*.o,*.pyc,*.swp

" persistent undo
set undodir=~/.vim/undodir
set undofile
set undolevels=1000
set undoreload=1000

" Defining a command to use :silent with programs that print to the terminal
" Uses :silent and :redraw! after running the command
command! -nargs=1 Silent
            \ | execute ':silent! ' .<q-args>
            \ | execute ':redraw!'

" Function to display which git branch we are currently into
" Taken from http://amix.dk/blog/post/19571 with some modifications
function! GitBranch()
    let branch = system("git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* //'")
    if branch != ''
        return ' branch: ' . substitute(branch, '\n','', 'g')
    en
    return ''
endfunction

" Function to run splint in the current buffer
function! RunSplint()
    let old_makeprg = &makeprg
    " Setting new variables
    set makeprg=splint\ %
    compiler splint
    execute ':make'
    " Restoring old values
    set makeprg=make
    compiler gcc
endfunction

" Status line options
set laststatus=2 " always show statusline
set statusline=%t\ %m\ buffer:%n\ format:%{&ff}\ \ %Y\ \ ascii:%03.3b\ hex:%02.2B\ %{GitBranch()}\ \ %l,%v

set showcmd

if has("syntax")
  syntax on
endif

" Setting highlight to extra whitespaces at end of the line
highlight ExtraWhitespace ctermbg=red guibg=red

if has("autocmd")
    autocmd InsertLeave * match ExtraWhitespace /\S\+\zs\s\+$/

    autocmd BufEnter *.mkd set ft=markdown
    autocmd BufEnter *.md set ft=markdown

    " Useful general options
    filetype plugin indent on

    " Disables any existing highlight
    autocmd VimEnter * nohl

    " Makefile sanity
    autocmd FileType make  set noet ts=4 sw=4

    " Gettext file compiler (msgfmt)
    autocmd FileType po compiler po

    " Python options
    autocmd FileType python :autocmd InsertLeave * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd FileType python set cinwords=if,elif,else,for,while,with,try,except,finally,def,class " better indentation
    autocmd FileType python set nosmartindent noautoindent keywordprg=pydoc2 textwidth=79
    autocmd FileType python set omnifunc=pythoncomplete#Complete                                  " setting the omnifuncion for python
    autocmd FileType python set expandtab completeopt-=preview
    autocmd FileType python nmap <F12> :Pylint<CR>
    autocmd FileType python compiler pylint

    " Haskell options
    autocmd FileType haskell set expandtab nocindent nosmartindent
    function! HaskellIncrementCols()
        let qflist = getqflist()
        for i in qflist
            let i.col += 1
        endfor
        call setqflist(qflist)
    endfunction
    au FileType haskell setl makeprg=ghci\ %
    au FileType haskell setl efm=%-G<interactive>:%.%#,%f:%l:%c:\ %m,%-G%.%#
    au FileType haskell au QuickFixCmdPost make call HaskellIncrementCols()

    " C and CPP options
    autocmd FileType c,cpp let g:compiler_gcc_ignore_unmatched_lines = 1
    autocmd FileType c,cpp set nosmartindent noautoindent cindent cinoptions=(0
    autocmd FileType c,cpp set completeopt-=preview               " disable omnicppcomplete scratch buffer
    autocmd FileType c,cpp syn keyword cType off64_t
    autocmd FileType c nmap <F12> :call RunSplint()<CR>

    " Save folds automatically on close, and load them on opening the file
    au BufWinLeave *.* mkview
    au BufWinEnter *.* silent loadview

endif

" Better behavior when browsing with h,j,k,l
nnoremap j gj
nnoremap k gk

" A more intuitive mapping for Y
map Y y$

" Hotkeys for easily editing/sourcing vimrc
nmap <Leader>sv :source $MYVIMRC<CR>
nmap <Leader>ev :edit $MYVIMRC<CR>

" Calling :Dox (needs DoxygenToolkit)
nmap <Leader>do :Dox<CR>

" Remapping :ls to execute a shell ls, not :buffer
cno ls !ls

" jumping between items in quickfix list
nmap <Leader>n :cnext<CR>
nmap <Leader>p :cprevious<CR>

" indent inside brackets
inoremap {<CR> {<CR>}<Esc><S-O>

" Open file name under cursor in another buffer
nmap gb :badd <cfile><CR>

" disabling the vim regexp extensions
nnoremap / /\v
vnoremap / /\v

" Clearing highlight
nnoremap <Leader><Space> :nohl<CR>

"" FN mappings
" Taglist's hotkeys
nnoremap <silent> <F2> :TagbarToggle<CR>
" NERDTree's hotkeys
nnoremap <F3> :NERDTree<CR>
" todo list
nnoremap <F4> <Plug>TaskList
" Set hotkey for regenerating tags
noremap <F5> :Silent !ctags -R --c-kinds=+pm --fields=+iaS --extra=+q -I *<CR>
" opening quickfix window
nnoremap <F6> :cwindow<CR>
" SingleCompile
nnoremap <F9> :Silent SCCompile<CR>
nnoremap <F10> :Silent SCCompileRun<CR>
set pastetoggle=<F11>
" F12 is reserved for per-filetype static analisys (splint, pylint and such)

" Automatically sourcing local configurations
if filereadable("./.vim_local_config")
    silent source ./.vim_local_config
endif

" Automatically sourcing a existing session if no files were passed as arguments
if filereadable("Session.vim") && (argc() == 0)
    silent source Session.vim
endif
