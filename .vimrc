"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This vimrc is based on the vimrc by Amix, URL:
"         http://www.amix.dk/vim/vimrc.html
" Maintainer: Easwy
" Version: 0.1
" Last Change: 31/05/07 09:17:57
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" => General
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Get opertion system name
let g:os = substitute(system('uname'), "\n", "", "")
if os == "SunOS"
  let os = "sunos"
elseif os == "Linux"
  let os = "linux"
elseif os == "CYGWIN_NT-6.1"
  let os = "cygwin"
elseif os == "Darwin"
  let os = "mac"
else
  let os = "windows"
endif

if match($TERM, "screen")!=-1
  set term=xtermc
endif
set t_Co=256
autocmd BufWritePost *
      \ if filereadable('tags') |
      \   call system('/usr/local/bin/ctags -a '.expand('%')) |
      \ endif
" With a map leader it's possible to do extra key combinations
let g:mapleader = ","
set ttymouse=xterm2

" Chinese
if os == "windows"
    set encoding=utf-8
    set langmenu=en_US
  let $LANG = 'en_US'
  language message zh_CN.UTF-8
  set fileencodings=ucs-bom,utf-8,gb18030,cp936,big5,euc-jp,euc-kr,latin1
endif
"Get out of VI's compatible mode..
set nocompatible

"clearcase make program
set makeprg=clearmake\ -C\ gnu

"unsave buffer can hide to backround
set hidden

"Sets how many lines of history VIM har to remember
set history=400

"Enable filetype plugin
filetype plugin on
filetype indent on

"Set to auto read when a file is changed from the outside
set autoread

"Have the mouse enabled all the time:
set mouse=a

"Set more undo
set nocp
set cpo-=<
set wcm=<C-Z>
"custom copy'n'paste
nmap <C-v><C-v> "+gP
vmap <C-v> "+gP
imap <C-v> <esc>"+gp
map <C-c> "+y
map <C-x> "+x 
"copy cut paste a word
nmap <silent> <leader>dd "adiw
nmap <silent> <leader>yy "ayiw
nmap <silent> <leader>pp viw"ap

if os == "cygwin"
    if !has("gui_running")
        " curors sharp change in different mode
        let &t_ti.="\e[1 q"
        let &t_SI.="\e[5 q"
        let &t_EI.="\e[1 q"
        let &t_te.="\e[0 q"
        "copy in cygwin vim
        function! Putclip(type, ...) range
            let sel_save = &selection
            let &selection = "inclusive"
            let reg_save = @@
            if a:type == 'n'
                silent exe a:firstline . "," . a:lastline . "y"
            elseif a:type == 'c'
                silent exe a:1 . "," . a:2 . "y"
            else
                silent exe "normal! `<" . a:type . "`>y"
            endif
            call writefile(split(@@,"\n"),'/dev/clipboard')
            let &selection = sel_save
            let @@ = reg_save
        endfunction
        vnoremap <silent> <leader>y :call Putclip(visualmode(), 1)<CR>
        nnoremap <silent> <leader>y :call Putclip('n', 1)<CR>
        "paste in cygwin vim
        function! Getclip()
            let reg_save = @@
            let @@ = join(readfile('/dev/clipboard'), "\n")
            setlocal paste
            exe 'normal p'
            setlocal nopaste
            let @@ = reg_save
        endfunction
        nnoremap <silent> <leader>p :call Getclip()<CR>
        "cut in cygwin vim
        function! Cutclip(type, ...) range
            let sel_save = &selection
            let &selection = "inclusive"
            let reg_save = @@
            if a:type == 'n'
                silent exe a:firstline . "," . a:lastline . "d"
            elseif a:type == 'c'
                silent exe a:1 . "," . a:2 . "d"
            else
            silent exe "normal! `<" . a:type . "`>d"
        endif
        call system('putclip', @@)
        let &selection = sel_save
        let @@ = reg_save
    endfunction
    " Cut via \x in normal or visual mode.
    vnoremap <silent> <leader>x :call Cutclip(visualmode(), 1)<CR>
    nnoremap <silent> <leader>x :call Cutclip('n', 1)<CR>
  endif
endif


"Fast remove highlight search
nmap <silent> <leader><cr> :noh<cr>

"Fast redraw
nmap <silent> <leader>rr :redraw!<cr>

"Fast edit vimrc
if os == 'windows'
  "Fast editing of _vimrc
  map <silent> <leader>ee :e ~/_vimrc<cr>
  "When _vimrc is edited, reload it
  autocmd! bufwritepost _vimrc source ~/_vimrc
else
  "Fast editing of .vimrc
  map <silent> <leader>ee :e ~/.vimrc"<cr>
  "When .vimrc is edited, reload it
  autocmd! bufwritepost .vimrc source ~/.vimrc
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" => Colors and Fonts
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set font according to system
if os == "windows"
  set guifont=vt100:h10
  set gfw=courier:h10:cGB2312
elseif os == "mac"
  set gfn=Monaco:h12
else
  set gfn=Monospace\ 9
  set shell=/bin/bash
endif

" Avoid clearing hilight definition in plugins
if !exists("g:vimrc_loaded")
  "Enable syntax hl
  syntax enable
  " color scheme
  if has("gui_running")
    set guioptions-=T
    colorscheme molokai
  else
    colorscheme desert256
  endif " has
endif " exists(...)

"Some nice mapping to switch syntax (useful if one mixes different languages in one file)
map <leader>$ :syntax sync fromstart<cr>
autocmd BufEnter * :syntax sync fromstart
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" => VIM user interface
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the curors - when moving vertical..
"set so=7

" Maximum window when GUI running
if has("gui_running")
  set lines=999
  set columns=999
endif

"Highlight current
if has("gui_running")
  set cursorline
endif

"Turn on WiLd menu
set wildmenu

"Always show current position
set ruler

"The commandbar is 2 high
set cmdheight=1

"Show line number
set nu

"Do not redraw, when running macros.. lazyredraw
set lz

"Change buffer - without saving
"set hid

"Set backspace
set backspace=eol,start,indent

"Bbackspace and cursor keys wrap to
set whichwrap+=<,>,h,l

"Ignore case when searching
"set ignorecase

"Include search
set incsearch

"Highlight search things
set hlsearch

"Set magic on
set magic

"No sound on errors.
set noerrorbells
set novisualbell
set t_vb=

"show matching bracets
set showmatch

"How many tenths of a second to blink
set mat=2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" My Menu
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:menu MyMenu.DelSpace    :%s/\s\+$//<CR>
:menu MyMenu.DelDosRet   :%s/\r//g<CR>
:menu MyMenu.ZipEmptyLines   :%s/^\n\+/\r/<CR>
:menu MyMenu.HexEdit     :%!xxd<CR>
:menu MyMenu.TextEdit    :%!xxd -r<CR>
" open menu in CLI vim
if !has("gui_running")
  :source $VIMRUNTIME/menu.vim
  :set wildmenu
  :set cpoptions-=<
  :set wildcharm=<C-Z>
  :map <F4> :emenu <C-Z>
endif
""""""""""""""""""""""""""""""
" Visual search
""""""""""""""""""""""""""""""
" From an idea by Michael Naumann
function! VisualSearch(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"
  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")
  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  else
    execute "normal /" . l:pattern . "^M"
  endif
  let @/ = l:pattern
  let @" = l:saved_reg
endfunction
"Basically you press * or # to search for the current selection !! Really useful
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
" Fast grep
function! s:GetVisualSelection()
  let save_a = @a
  silent normal! gv"ay
  let v = @a
  let @a = save_a
  let var = escape(v, '\\/.$*')
  return var
endfunction

nmap <leader>ag :Ag -t -G "cc\|hh" <C-R>=expand("<cword>")<CR><CR>
nmap <silent> <leader>lv :lv /<c-r>=expand("<cword>")<cr>/ %<cr>:lw<cr>
vmap <silent> <leader>lv :lv /<c-r>=<sid>GetVisualSelection()<cr>/ %<cr>:lw<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ctags related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if os == "windows"
  let g:vimrc_splitstr = '\'
else
  let g:vimrc_splitstr = '/'
endif
set tags=/var/vobs/sp/se/se/tags,/VOBS/ngn_sx/sigtran_apps/tags,/VOBS/ngn_sx/ss7/tags,/VOBS/ngn_sx/diam_apps/tags,/VOBS/ngn_thirdParty/Hughes/common_ol/tags,/VOBS/ngn_thirdParty/Hughes/cspl_ol/tags

nmap <silent> <leader>at :!ctags -R --links=no --fields=+iaS --extra=+q --exclude=intif .<CR>
    \:set tags+=tags<CR>
nmap <silent> <leader>ac :!find . -iname '*.c' -o -iname '*.cpp' -o -iname '*.cc' -o -iname '*.h' -o -iname '*.hpp' -o -iname '*.hh' > cscope.files<CR>
  \:!cscope -b -i cscope.files -f cscope.out<CR>
  \:cs reset<CR>

function! Add_tags()
  let dir = getcwd()
  let curtags = dir.g:vimrc_splitstr."tags"
  let curtags=substitute(curtags,'\\','\','g')
  if filereadable(curtags)
    exec "set tags+=".curtags
    echohl WarningMsg | echo "Succ to add tags![".curtags."]" | echohl None
  else
    echohl WarningMsg | echo "Fail to add tags! No tags in this file's path.[".curtags."]" | echohl None
  endif
  let curcscope = dir.g:vimrc_splitstr."cscope.out"
  let curcscope=substitute(curcscope,'\\','\','g')
  if filereadable(curcscope)
    exec "set tags+=".curtags
    exec "cscope add ".curcscope
    echohl WarningMsg | echo "Succ to add cscope.out![".curcscope."]" | echohl None
  else
    echohl WarningMsg | echo "Fail to add cscope.out! No in this file's path.[".curcscope."]" | echohl None
  endif
endfunction
function! Del_tags()
  let dir = getcwd()
  let curtags = dir.g:vimrc_splitstr."tags"
  let curtags=substitute(curtags,'\\','\','g')
  let curcscope = dir.g:vimrc_splitstr."cscope.out"
  let curcscope=substitute(curcscope,'\\','\','g')
  exec "set tags-=".curtags
  exec "cscope del ".curcscope
  if filereadable(curtags)
    echohl WarningMsg | echo "Succ to del tags![".curtags."]" | echohl None
  else
    echohl WarningMsg | echo "Succ to del tags! But no tags in this file's path.[".curtags."]" | echohl None
  endif
endfunction
nmap <silent> <leader>ta :call Add_tags()<CR>
nmap <silent> <leader>td :call Del_tags()<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" =>Moving around and tabs
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Moving fast to front, back and 2 sides ;)
imap <m-0> <esc>$a
imap <m-1> <esc>^i
"Move a line of text using alt
nmap <m-j> mz:m+<cr>`z
nmap <m-k> mz:m-2<cr>`z
vmap <m-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <m-k> :m'<-2<cr>`>my`<mzgv`yo`z
"Switch to current dir
map <silent> <leader>cd :cd %:p:h<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Parenthesis/bracket expanding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Map auto complete of (, ", ', [
vnoremap ( <esc>`>i)<esc>`<i(<esc>
vnoremap [ <esc>`>i]<esc>`<i[<esc>
vnoremap { <esc>`>o}<esc>`<i{<cr><esc>k=%
nmap ( vi(
nmap [ vi[
nmap { vi{
"inoremap <leader>( (<esc>$a)<esc>i
"inoremap <leader>[ [<esc>$a]<esc>i
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Files and backups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Turn backup off
set nobackup
set nowb
"set noswapfile
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Enable folding, I find it very useful
set fdc=3
set fdm=syntax
set nofen
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=4
map <leader>t2 :set shiftwidth=2<cr>
map <leader>t4 :set shiftwidth=4<cr>
au FileType html,python,vim,javascript
"setl receiveDispReq
"au FileType html,python,vim,javascript setl tabstop=2
au FileType java,c setl shiftwidth=4
"au FileType java setl tabstop=4
au FileType txt setl lbr
au FileType txt setl tw=78
set smarttab
""""""""""""""""""""""""""""""
" Indent
""""""""""""""""""""""""""""""
"Auto indent
set ai
"Smart indet
set si
"C-style indeting
set cindent
"Wrap lines
set wrap
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Pressing ,ss will toggle and untoggle spell checking
"map <leader>ss :setlocal spell!<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Complete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" options
set completeopt=menu
set complete-=u
set complete-=i
" mapping
inoremap <expr> <CR>       pumvisible()?"\<C-Y>":"\<CR>"
inoremap <expr> <C-J>      pumvisible()?"\<PageDown>\<C-N>\<C-P>":"\<C-X><C-O>"
inoremap <expr> <C-K>      pumvisible()?"\<PageUp>\<C-P>\<C-N>":"\<C-K>"
inoremap <expr> <C-U>      pumvisible()?"\<C-E>":"\<C-U>"
inoremap <C-]>             <C-X><C-]>
inoremap <C-F>             <C-X><C-F>
inoremap <C-D>             <C-X><C-D>
inoremap <C-L>             <C-X><C-L>
" Enable syntax
if has("autocmd") && exists("+omnifunc")
  autocmd Filetype *
        \if &omnifunc == "" |
        \  setlocal omnifunc=syntaxcomplete#Complete |
        \endif
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" =>Plugin configuration
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle setting 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible 
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'Lokaltog/vim-powerline'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'peterjmorgan/mark-2.8.0'
"Bundle 'xolox/vim-easytags'
"Bundle 'xolox/vim-misc'
Bundle 'mbbill/code_complete'
" vim-scripts repos
Bundle 'taglist.vim'
Bundle 'The-NERD-tree'
"Bundle 'c.vim'
Bundle 'a.vim'
Bundle 'Align'
Bundle 'VisIncr'
Bundle 'ccase.vim'
"Bundle 'snipMate'
Bundle 'DoxygenToolkit.vim'
Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'EasyGrep'
"Bundle 'DrawIt'
Bundle 'cmdline-completion'
Bundle 'OmniCppComplete'
Bundle 'YankRing.vim'
Bundle 'The-NERD-Commenter'
Bundle 'EasyMotion'
Bundle 'rking/ag.vim'
Bundle 'Auto-Pairs'
Bundle 'syntastic'
Bundle 'AutoTag'
" non github repos
" Bundle 'git://git.wincent.com/command-t.git'
" git repos on your local machine (ie. when working on your own plugin)
" Bundle 'file:///Users/gmarik/path/to/plugin'
" ...

filetype plugin indent on     " required!
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed...
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OmniTags setting 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> <leader>t <ESC>:OmniTagsLoad tags<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" easytags setting 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set tags=/cygdrive/d/Source/diam_apps/tags
"let g:easytags_dynamic_files = 1
"let g:easytags_events = ['BufWritePost']
"let g:easytags_auto_highlight = 0
"let g:easytags_include_members = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FuzzyFinder setting 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if os == "mac"
    let g:fuf_buffertag_ctagsPath="/usr/local/bin/ctags"
endif
let g:fuf_modesDisable = []
nmap <leader>ff :FufFile<CR>
nmap <leader>fc :FufCoverageFile<CR>
nmap <leader>fb :FufBuffer<CR>
nmap <leader>fd :FufBookmarkDir<CR>
nmap <leader>ft :FufBufferTag<CR>
nmap <leader>fm :FufMruFile<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"if has("cscope")
"set csprg=/home/zhangxy/bin/cscope
set csto=1
set cst
set nocsverb
" add any database in current directory
if filereadable("cscope.out")
   cs add cscope.out
endif
set cscopequickfix=c-,d-,e-,g-,i-,s-,t-
set csverb
"   's'   symbol: find all references to the token under cursor
nmap <leader>ss :cs find s <C-R>=expand("<cword>")<CR><CR>
vmap <leader>ss :cs find s <C-R><sid>GetVisualSelection()<CR><CR>
"   'g'   global: find global definition(s) of the token under cursor
nmap <leader>sg :cs find g <C-R>=expand("<cword>")<CR><CR>
"   'c'   calls:  find all calls to the function name under cursor
nmap <leader>sc :cs find c <C-R>=expand("<cword>")<CR><CR>
"   't'   text:   find all instances of the text under cursor
nmap <leader>st :cs find t <C-R>=expand("<cword>")<CR><CR>
"   'e'   egrep:  egrep search for the word under cursor
nmap <leader>se :cs find e <C-R>=expand("<cword>")<CR><CR>
"   'f'   file:   open the filename under cursor
nmap <leader>sf :cs find f <C-R>=expand("<cfile>")<CR><CR>
"   'i'   includes: find files that include the filename under cursor
nmap <leader>si :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"   'd'   called: find functions that function under cursor calls
nmap <leader>sd :cs find d <C-R>=expand("<cword>")<CR><CR>
""""""""""""""""""""""""""""""
" Doxygen setting
""""""""""""""""""""""""""""""
map <silent> <Leader>dg : Dox<cr>
let g:DoxygenToolkit_briefTag_pre="@Brief  "
let g:DoxygenToolkit_paramTag_pre="@Param  "
let g:DoxygenToolkit_returnTag="@Returns  "
let g:DoxygenToolkit_dateTag="@Date  "
let g:DoxygenToolkit_blockHeader="---------------------------------------------------------------------------"
let g:DoxygenToolkit_blockFooter="---------------------------------------------------------------------------"
let g:DoxygenToolkit_authorName="Zhangxy"
let g:DoxygenToolkit_licenseTag="ASB CPG license"
let g:DoxygenToolkit_briefTag_funcName = "yes"
""""""""""""""""""""""""""""""
" NERDTree setting
""""""""""""""""""""""""""""""
nmap <silent> <leader>nt :NERDTreeToggle<cr>
let NERDTreeShowBookmarks = 1
let NERDTreeDirArrows=0
""""""""""""""""""""""""""""""
" Alternate files quickly setting
""""""""""""""""""""""""""""""
let g:alternateExtensions_{'hh'} = "cc"
let g:alternateExtensions_{'cc'} = "hh"
""""""""""""""""""""""""""""""
" taglist setting
""""""""""""""""""""""""""""""
nmap <silent> <leader>tl :Tlist<cr>
if os == "mac"
    let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"
else
    let Tlist_Ctags_Cmd = "ctags"
endif
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
let Tlist_Compact_Format = 1
let Tlist_Use_Horiz_Window = 0
let Tlist_Auto_Open = 0
""""""""""""""""""""""""""""""
" netrw setting
""""""""""""""""""""""""""""""
nmap <silent> <leader>fe :Sexplore!<cr>
""""""""""""""""""""""""""""""
" yank ring setting
""""""""""""""""""""""""""""""
map <leader>yr :YRShow<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" =>Filetype generic
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fileformats
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Favorite filetypes
set ffs=unix,dos,mac "Default file types
nmap <leader>ffd :se ff=dos<cr>
nmap <leader>ffu :se ff=unix<cr>
"""""""""""""""""""""""""""""""
" Vim
"""""""""""""""""""""""""""""""
autocmd FileType vim set nofen
autocmd FileType vim map <buffer> <leader><space> :w!<cr>:source %<cr>
""""""""""""""""""""""""""""""
" C/C++
"""""""""""""""""""""""""""""""
autocmd FileType c,cpp  map <buffer> <leader><space> :w!<cr>:make
"autocmd FileType c,cpp  setl foldmethod=syntax | setl fen
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" =>MISC
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Quickfix
nmap <leader>qn :cn<cr>
nmap <leader>qp :cp<cr>
nmap <leader>qw :cw 10<cr>
"nmap <leader>cc :botright lw 10<cr>
"map <c-u> <c-l><c-j>:q<cr>:botright cw 10<cr>
" Fast diff
cmap <leader>vd vertical diffsplit
set diffopt=vertical
"Paste toggle - when pasting something in, don't indent.
"set pastetoggle=<F3>
"Remove indenting on empty lines
"map <F2> :%s/\s*$//g<cr>:noh<cr>''
"Super paste
"inoremap <C-v> <esc>:set paste<cr>mui<C-R>+<esc>mv'uV'v=:set nopaste<cr>
"Fast Ex command
nnoremap ; :
