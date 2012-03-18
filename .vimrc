" Ivan Sichmann Freitas <ivansichfreitas (_at_) gmail (_dot_) com>

set nocompatible  " VIM POWER!!!!
set encoding=utf8
set conceallevel=2

" Pathogen
call pathogen#runtime_append_all_bundles()

set synmaxcol=200
set showmatch     " Show matching brackets (briefly jump to it)
set splitright
set nosplitbelow
set magic
set backspace=indent,eol,start

" Backup and history options
set backupdir+=~/.vim/backup " Put backup files (annoying ~ files) in another directory
set history=1000             " Increase history size
set background=dark          " Set best color scheme to dark consoles
set autoread                 " automagically reloads a file if it was externally modified
set textwidth=80             " don't break long lines
set formatoptions=cqrn1

" list chars
set list
set listchars=tab:▸\ ,

" Appearance
set title      " Change the terminal title
set modelines=0
set ttyfast    " Smooth editing
set showmode
set number
set hidden
set nowrap     " don't visually breaks long lines
set t_Co=256   " setting the number of colors
set guitablabel=%n\ %f
set showcmd
set showfulltag

if has("gui_running")
    set guioptions=agit " setting a less cluttered gvim
    set guifont=Terminus\ 10
    colorscheme solarized
else
    let g:solarized_menu = 0
    let g:solarized_termcolors = 256
    let g:solarized_termtrans = 1
    let g:solarized_bold = 0
    let g:solarized_underline = 0
    let g:solarized_italic = 0
    colorscheme solarized
endif

" Indentation
set shiftwidth=4
set tabstop=4
set softtabstop=4
set shiftround
set expandtab

" Searching
set hlsearch   " highlight search results
set incsearch  " incremental search
set ignorecase
set infercase
set smartcase
set nogdefault " don't use global as default in substitutions

" Better completion menu
set wildmenu
set wildmode=longest,full
set wildignore+=*.o,*.pyc,*.swp

" persistent undo
set undodir=~/.vim/undodir
set undofile
set undolevels=1000
set undoreload=1000

function! IsPasting ()
    if &paste == "1"
        return " [paste] "
    else
        return " "
    endif
endfunction

function! SetPastetoggle()
    if &paste == "1"
        set nopaste
    else
        set paste
    endif
    redraw
endfunction

" Status line options
set laststatus=2 " always show statusline
set statusline=%t " title
set statusline+=%{IsPasting()} " paste status"
set statusline+=%m\  " modified or not
set statusline+=buffer:%n\  " buffer number
set statusline+=%{&ff}\ \ %y\ \  " file format (unix, windows) and type
set statusline+=ascii:%03.3b\ hex:%02.2B\ \  " ascii value of the character under cursor
set statusline+=%4l,%2.3v\ %LL\  " current line and column and total of lines in file"
set statusline+=%{SyntasticStatuslineFlag()}

command! -nargs=0 UpdateHelp helptags ~/.vim/doc

" Defining a command to use :silent with programs that print to the terminal
" Uses :silent and :redraw! after running the command
command! -nargs=1 Silent
            \ | execute ':silent! ' .<q-args>
            \ | execute ':redraw!'

" Set the currently indentention style for GNU
function! GnuIndent()
    setlocal cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
    setlocal shiftwidth=2
    setlocal tabstop=8
endfunction

command! -nargs=0 GnuIndent call GnuIndent()

" Specific for hacking coreutils
function! CoreutilsIndent()
    if match(getcwd(), "coreutils") > 0
        call GnuIndent()
        setlocal expandtab
    endif
endfunction

" C syntax options (see :help c.vim)
let c_syntax_for_h    = 0 " use c syntax to .h files instead of c++ syntax
let c_space_errors    = 0 " trailing whitespave or spaces before tabs
let c_comment_strings = 0 " highligh numbers and strings insede comments
let c_no_comment_fold = 1 " disable syntax based folding for comments
let c_gnu             = 1 " highlight gnu extensions
let c_minlines        = 100

" AutoComplPop
let g:acp_completeoptPreview    = 1
let g:acp_behaviorKeywordLength = 4
let g:acp_mappingDriven         = 1

" EnhancedCommentify
let g:EnhCommentifyMultiPartBlocks = 'yes'
let g:EnhCommentifyAlignRight      = 'yes'
let g:EnhCommentifyPretty          = 'yes'
let g:EnhCommentifyFirstLineMode   = 'yes'
let g:EnhCommentifyRespectIndent   = 'yes'
let g:EnhCommentifyUseBlockIndent  = 'yes'
let g:EnhCommentifyBindInNormal    = 'no'
let g:EnhCommentifyBindInVisual    = 'no'
let g:EnhCommentifyBindInInsert    = 'no'

" Lua
let g:lua_complete_omni     = 1
let g:lua_compiler_name     = '/usr/bin/luac'
let g:lua_check_syntax      = 1
let g:lua_complete_keywords = 1
let g:lua_complete_globals  = 1
let g:lua_complete_library  = 1
let g:lua_complete_dynamic  = 1

" Lisp
let g:lisp_rainbow = 1

" Doxygen syntax
let g:load_doxygen_syntax=1

" Python
let g:pyindent_open_paren    = '&sw'
let g:pyindent_nested_paren  = '&sw'
let g:pyindent_continue      = '&sw *2'
let g:python_highlight_all   = 1
let python_print_as_function = 1

" syntastic
let g:syntastic_enable_signs        = 1
let g:syntastic_check_on_open       = 0
let g:syntastic_echo_current_error  = 0
let g:syntastic_auto_jump           = 0
let g:syntastic_enable_highlighting = 1
let g:syntastic_auto_loc_list       = 2
let g:syntastic_quiet_warnings      = 0
let g:syntastic_stl_format          = 'E:%e,W:%w'
let g:syntastic_mode_map            = { 'mode'              : 'passive',
                                      \ 'active_filetypes'  : [],
                                      \ 'passive_filetypes' : ['c', 'cpp', 'python', 'tex']}

" vhdl syntax configuration
let g:vhdl_indent_genportmap = 0
let g:vhdl_indent_rhsassign = 1

" TagHighlight
let g:TagHighlightSettings = { 'IncludeLocals': 'False' }

" haskell syntax highlighting configuration
let hs_highlight_types      = 1
let hs_highlight_more_types = 1
let hs_highlight_boolean    = 1

" Tagbar configurations
let g:tagbar_left = 1

" TaskList configuration
let g:tlTokenList = ['TODO', 'FIXME', 'NOTE', 'HACK', 'XXX']

" Haskell
let g:haddock_browser = "/usr/bin/luakit"

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
let g:tex_comment_nospell=1
let g:tex_stylish=1
let g:tex_conceal="admgs"

" ManPageView
let g:manpageview_winopen = "hsplit="

" C highlighting
hi DefinedByUser ctermfg=lightgrey guifg=blue
hi cBraces ctermfg=lightgreen guifg=lightgreen
hi link cUserFunction DefinedByUser
hi link cUserFunctionPointer DefinedByUser

if has("syntax")
  syntax on
endif

" Setting highlight to extra whitespaces at end of the line
highlight ExtraWhitespace ctermbg=red guibg=red

if has("autocmd")
    autocmd BufEnter,InsertLeave * match ExtraWhitespace /\S\+\zs\s\+$/

    autocmd BufEnter *.rl setl ft=ragel

    autocmd BufEnter *.mips setl ft=mips

    autocmd Filetype asm,mips setl autoindent

    autocmd BufEnter *.c,*.h call CoreutilsIndent()

    " conkyrc syntax
    autocmd BufEnter *conkyrc* setl ft=conkyrc

    " Useful general options
    filetype plugin indent on

    " Disables any existing highlight
    autocmd VimEnter * nohl

    " Makefile sanity
    autocmd FileType make  setl noet ts=4 sw=4

    " Gettext file compiler (msgfmt)
    autocmd FileType po compiler po

    autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags

    " Mail
    autocmd FileType mail :autocmd InsertLeave * match none
    autocmd FileType mail set spell spelllang=br,en_us

    " Lisp
    autocmd FileType lisp setl lisp showmatch cpoptions-=m
    autocmd FileType lisp :AutoCloseOff

    " Python options
    autocmd FileType python :autocmd InsertLeave * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd FileType python setl cinwords=if,elif,else,for,while,with,try,except,finally,def,class " better indentation
    autocmd FileType python setl nosmartindent noautoindent keywordprg=pydoc2 textwidth=79
    autocmd FileType python setl omnifunc=pythoncomplete#Complete                                  " setting the omnifuncion for python
    autocmd FileType python setl expandtab completeopt-=preview

    " Haskell options
    autocmd FileType haskell setl expandtab nocindent nosmartindent
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
    autocmd FileType c,cpp setl et nosmartindent noautoindent cindent cinoptions=(0
    autocmd FileType c,cpp setl completeopt-=preview               " disable omnicppcomplete scratch buffer
    autocmd FileType c,cpp syn keyword cType off64_t

    " Tex, LaTeX
    autocmd FileType tex,latex setl smartindent
    autocmd FileType tex,latex setl spell spelllang=br,en_us

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

" Make gf edite the file even if ti doesn't exist
nmap gf :e <cfile><CR>

" jumping between items in quickfix list
nmap <Leader>n :cnext<CR>
nmap <Leader>p :cprevious<CR>

" indent inside brackets
inoremap {<CR> {<CR>}<Esc><S-O>

" Open file name under cursor in another buffer
nmap gb :badd <cfile><CR>

noremap <C-k> <C-y>
noremap <C-j> <C-e>

" Clearing highlight
nnoremap <Leader><Space> :nohl<CR>

" Fix arrow keys
nnoremap <Esc>OA <Up>
vnoremap <Esc>OA <Up>
inoremap <Esc>OA <Up>
nnoremap <Esc>OB <Down>
vnoremap <Esc>OB <Down>
inoremap <Esc>OB <Down>
nnoremap <Esc>OC <Right>
vnoremap <Esc>OC <Right>
inoremap <Esc>OC <Right>
nnoremap <Esc>OD <Left>
vnoremap <Esc>OD <Left>
inoremap <Esc>OD <Left>

" Fix wrong slash (some notebooks with Fn key)
nnoremap <Esc>Oo /
inoremap <Esc>Oo /
vnoremap <Esc>Oo /
cnoremap <Esc>Oo /

" Proper behavior for arrow keys
vnoremap <S-Up> <Up>
inoremap <S-Up> <Up>
nnoremap <S-Up> <Up>
vnoremap <S-Down> <Down>
inoremap <S-Down> <Down>
nnoremap <S-Down> <Down>

" EnhancedCommentify
vmap <Leader>cm <Plug>VisualComment
nmap <Leader>cm <Plug>Comment
vmap <Leader>dm <Plug>VisualDeComment
nmap <Leader>dm <Plug>DeComment

"" FN mappings
" Taglist's hotkeys
nnoremap <silent> <F2> :TagbarToggle<CR>
" NERDTree's hotkeys
nnoremap <F3> :NERDTreeToggle<CR>
" todo list
nnoremap <F4> :TaskList<CR>
" Set hotkey for regenerating tags
command! -nargs=0 UpdateTags
            \ | execute ':Silent !ctags -R --c-kinds=+pm --fields=+iaS --extra=+q -I *'
            \ | execute ':UpdateTypesFileOnly'
noremap <F5> :UpdateTags<CR>
" opening quickfix window
nnoremap <F6> :cwindow<CR>
" gundo
nnoremap <F7> :GundoToggle<CR>
" gitv
nnoremap <F8> :Gitv
"set pastetoggle=<F11>
nnoremap <F11> :Silent call SetPastetoggle()<CR>
nnoremap <F12> :SyntasticCheck<CR>

hi! link NonText Normal
hi! link SpecialKey Normal

" Automatically sourcing local configurations
if filereadable("./.vim_local_config")
    silent source ./.vim_local_config
endif

" Automatically sourcing a existing session if no files were passed as arguments
if filereadable("Session.vim") && (argc() == 0)
    silent source Session.vim
endif
