" jakalada's .vimrc

"===============
" Initialize {{{
"===============

" .vimrcの再読み込み時にオプションを初期化する {{{
" 設定されたruntimepathが初期化されないようにする
let s:tmp = &runtimepath
set all&
let &runtimepath = s:tmp
unlet s:tmp
" }}}

let s:iswin = has('win32') || has('win64')

let s:isgui = has("gui_running")

if s:iswin
  " For Windows {{{
  language message en

  " すでに読み込まれているファイル名には影響がないので注意する
  set shellslash

  let $DOTVIMDIR = expand('~/vimfiles')

  let $DROPBOXDIR = expand('~/Dropbox')

  let $VIMCONFIGDIR = expand('~/project/vim-dotfiles')
  " }}}
else
  " For Linux {{{
  language message C

  let $DOTVIMDIR = expand('~/.vim')

  let $DROPBOXDIR = expand('~/Dropbox')

  let $VIMCONFIGDIR = expand('~/project/vim-dotfiles')
  " }}}
endif

" pathogen.vim {{{
filetype off

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

filetype on
filetype plugin on
filetype indent on
" }}}

" }}}

"=============
" Commands {{{
"=============

" .vimrcの再読み込み時に.vimrc内で設定されたautocmdを初期化する
" MyAutocmdを使用することで漏れなく初期化できる
" {{{
augroup vimrc
    autocmd!
augroup END

command!
\   -bang -nargs=*
\   MyAutocmd
\   autocmd<bang> vimrc <args>
" }}}

" 定義されているマッピングを調べるコマンドを定義する
" {{{
command!
\   -nargs=* -complete=mapping
\   AllMaps
\   map <args> | map! <args> | lmap <args>
" }}}

" For rails.vim
 " {{{
if s:iswin
  command!
\   -bar -nargs=1
\   OpenURL
\   :!start cmd /cstart /b <args>
else
  command!
\   -bar -nargs=1
\   OpenURL
\   :VimProcBang firefox <args>
endif
" }}}

" }}}

"==============
" Functions {{{
"==============

" statullineの設定に使用する
function! SnipMid(str, len, mask) " {{{
  if a:len >= len(a:str)
    return a:str
  elseif a:len <= len(a:mask)
    return a:mask
  endif

  let len_head = (a:len - len(a:mask)) / 2
  let len_tail = a:len - len(a:mask) - len_head

  return (len_head > 0 ? a:str[: len_head - 1] : '') . a:mask . (len_tail > 0 ? a:str[-len_tail :] : '')
endfunction
" }}}

" }}}

"=============
" Encoding {{{
"=============

" fileencodingの設定 {{{
set fileencodings=iso-2022-jp-3,iso-2022-jp,euc-jisx0213,euc-jp,utf-8,ucs-bom,euc-jp,eucjp-ms,cp932
set encoding=utf-8

" マルチバイト文字が含まれていない場合はencodingの値を使用する
MyAutocmd BufReadPost *
\   if &modifiable && !search('[^\x00-\x7F]', 'cnw')
\ |   setlocal fileencoding=
\ | endif
" }}}

" fileformatの設定 {{{
if s:iswin
  set fileformat=dos
else
  set fileformat=unix
endif

set fileformats=unix,dos,mac
" }}}

"East Asian Width Class Ambiguous な文字をASCII文字の2倍の幅で扱う
set ambiwidth=double
"}}}

"===========
" Syntax {{{
"===========

syntax enable

if s:isgui
  colorscheme zenburn
else
  colorscheme wombat256mod
endif

" ft-ruby-syntax
let ruby_operators = 1
let ruby_fold = 1

" ft-java-syntax
let g:java_highlight_functions = 'style'
let g:java_highlight_all = 1
let g:java_allow_cpp_keywords = 1

" ft-php-syntax
let g:php_folding = 1

" ft-python-syntax
let g:python_highlight_all = 1

" ft-xml-syntax
let g:xml_syntax_folding = 1

" ft-vim-syntax
let g:vimsyntax_noerror = 1

" ft-sh-syntax
let g:is_bash = 1

" }}}

"============
" Options {{{
"============


if s:isgui
  set nocursorline
  set cmdheight=3
  set showtabline=2
  set guioptions=gae
  set guifont=Ricty\ Discord\ 13.5
  set guitablabel=%-30.30t
  set mouse=a
  set mousehide
  set mousefocus
endif

setlocal autoindent
setlocal smartindent
setlocal smarttab
setlocal expandtab

setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal shiftround

set backspace=indent,eol,start

setlocal matchpairs+=<:>

setlocal iskeyword+=-

set hidden

set directory-=.
if v:version >= 703
  set undofile
  let &undodir=&directory
endif

if has('virtualedit')
  set virtualedit=block
endif

set scrolloff=10

set helplang=ja

MyAutocmd WinEnter * checktime

" tags
if has('path_extra')
    set tags+=./tags;
    set tags+=tags;
    set tags+=$DOTVIMDIR/systags;
endif
set showfulltag
set notagbsearch

if has('unix')
  set nofsync
  set swapsync=
endif

" search {{{
set incsearch
set ignorecase
set smartcase
set wrapscan

nnoremap <silent> / :<C-U>setlocal hlsearch<CR>/
nnoremap <silent> ? :<C-U>setlocal hlsearch<CR>?
nnoremap <silent> n :<C-U>setlocal hlsearch<CR>n
nnoremap <silent> N :<C-U>setlocal hlsearch<CR>N
nnoremap <silent> v :<C-U>setlocal nohlsearch<CR>v
nnoremap <silent> <C-V> :<C-U>setlocal nohlsearch<CR><C-V>
nnoremap <silent> V :<C-U>setlocal nohlsearch<CR>V
MyAutocmd InsertEnter * setlocal nohlsearch
" }}}

set linespace=3

set number

set showcmd

set noequalalways

set list
set listchars=tab:>-,trail:-

set wrap

set textwidth=0

" statusline {{{
set laststatus=2
let &statusline="%{winnr('$')>1?'['.winnr().'/'.winnr('$').(winnr('#')==winnr()?'#':'').']':''}\ %{expand('%:p:.')}\ %<\(%{SnipMid(getcwd(),80-len(expand('%:p:.')),'...')}\)\  %=%m%y%{'['.(&fenc!=''?&fenc:&enc).','.&ff.']'}\ %3p%%"
" }}}

" }}}

"=================
" Key-mappings {{{
"=================

"-----------
" Leader {{{
"-----------

let mapleader = ' '
let g:mapleader = ' '
let g:maplocalleader = '\'

nnoremap <Space> <Nop>
xnoremap <Space> <Nop>
nnoremap \ <Nop>
xnoremap \ <Nop>
" }}}

"----------------
" mapmode-nvo {{{
"----------------

noremap j gj
noremap k gk
noremap <C-J> <C-D>
noremap <C-K> <C-U>
noremap <C-L> <C-E>
noremap <C-H> <C-Y>

noremap L $
noremap H ^
noremap gj L
noremap gm M
noremap gk H
" }}}

"--------------
" mapmode-n {{{
"--------------

nnoremap <Backspace> <C-O>
nnoremap <S-Backspace> <C-I>

nnoremap <silent> <leader><leader> :<C-U>write<CR>

nnoremap <C-Up> <C-A>
nnoremap <C-Down> <C-X>

nnoremap Q q
nnoremap <silent> q :<C-U>close<CR>

nnoremap <C-Backspace> <C-^>

nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" }}}

"--------------
" mapmode-i {{{
"--------------

inoremap jj <Esc>

inoremap <C-K> <Esc>O
inoremap <C-J> <Esc>o

inoremap <silent> <C-L> <Esc>/['"()[\]<>{}]<CR>a
inoremap <silent> <C-H> <Left>

inoremap <silent> <F7> <Esc>gUiwea
" }}}

" }}}

"===================
" 少し大きい設定 {{{
"===================

"-----------------------------------------
" vim-statusline {{{
" https://github.com/fuenor/vim-statusline
" ----------------------------------------
scriptencoding=utf-8

" 挿入モード時、ステータスラインの色を変更
"
" このファイルの内容をそのまま.vimrc等に追加するか、
" pluginフォルダへこのファイルをコピーします。

" 挿入モード時の色指定
if !exists('g:hi_insert')
  let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'
endif

" Linux等でESC後にすぐ反映されない場合、次行以降のコメントを解除してください
" if has('unix') && !has('gui_running')
"   " ESC後にすぐ反映されない場合
"   inoremap <silent> <ESC> <ESC>
"   inoremap <silent> <C-[> <ESC>
" endif

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction
" }}}

"---------------------
" tab page mapping {{{
"---------------------

nnoremap <SID>[tab] <Nop>
nmap t <SID>[tab]

nnoremap <silent> <SID>[tab]l :<C-U>tabnext<CR>
nnoremap <silent> <SID>[tab]h :<C-U>tabprev<CR>
nnoremap <silent> <SID>[tab]q :<C-U>tabclose<CR>
nnoremap <silent> <SID>[tab]tt :<C-U>tabnew<CR>

nnoremap <silent> <SID>[tab]tn :<C-U>tabnew \| lcd $DROPBOXDIR/Notes<CR>
nnoremap <silent> <SID>[tab]tg :<C-U>tabnew \| lcd $DROPBOXDIR/GTD<CR>
nnoremap <silent> <SID>[tab]tv :<C-U>tabnew \| lcd $VIMCONFIGDIR<CR>
" }}}

"-------------------
" window mapping {{{
"-------------------

nnoremap <SID>[window] <Nop>
nmap $ <SID>[window]

nnoremap <Tab> <C-W>w
nnoremap <S-Tab> <C-W>W

nmap <SID>[window]sj <SID>(split-to-j)
nmap <SID>[window]sk <SID>(split-to-k)
nmap <SID>[window]sh <SID>(split-to-h)
nmap <SID>[window]sl <SID>(split-to-l)

nnoremap <silent> <SID>(split-to-j) :<C-U>execute 'belowright' (v:count == 0 ? '' : v:count) 'split'<CR>
nnoremap <silent> <SID>(split-to-k) :<C-U>execute 'aboveleft'  (v:count == 0 ? '' : v:count) 'split'<CR>
nnoremap <silent> <SID>(split-to-h) :<C-U>execute 'topleft'    (v:count == 0 ? '' : v:count) 'vsplit'<CR>
nnoremap <silent> <SID>(split-to-l) :<C-U>execute 'botright'   (v:count == 0 ? '' : v:count) 'vsplit'<CR>
" }}}

"------------------------
" Command-line window {{{
"------------------------

nnoremap <SID>(command-line-enter) q:
xnoremap <SID>(command-line-enter) q:
nnoremap <SID>(command-line-norange) q:<C-U>

nnoremap ; <Nop>
xnoremap ; <Nop>

nmap ; <SID>(command-line-enter)
xmap ; <SID>(command-line-enter)

nmap <leader>h <SID>(command-line-enter)help<Space>
nnoremap <silent> <leader>hh :<C-U>help<Space><C-R><C-W><CR>

MyAutocmd CmdwinEnter * call s:init_cmdwin()
function! s:init_cmdwin() " {{{
  nnoremap <silent> <buffer> q :<C-U>quit<CR>
  startinsert!
endfunction " }}}
" }}}

"---------------------------------
" 空行を追加と削除を容易にする {{{
"---------------------------------

function! AddEmptyLineBelow() " {{{
  call append(line("."), "")
endfunction " }}}

function! AddEmptyLineAbove() " {{{
  let l:scrolloffsave = &scrolloff
  " Avoid jerky scrolling with ^E at top of window
  set scrolloff=0
  call append(line(".") - 1, "")
  if winline() != winheight(0)
    silent normal! <C-E>
  end
  let &scrolloff = l:scrolloffsave
endfunction " }}}

function! DelEmptyLineBelow() " {{{
  if line(".") == line("$")
    return
  end
  let l:line = getline(line(".") + 1)
  if l:line =~ '^\s*$'
    let l:colsave = col(".")
    .+1d
    ''
    call cursor(line("."), l:colsave)
  end
endfunction " }}}

function! DelEmptyLineAbove() " {{{
  if line(".") == 1
    return
  end
  let l:line = getline(line(".") - 1)
  if l:line =~ '^\s*$'
    let l:colsave = col(".")
    .-1d
    silent normal! <C-Y>
    call cursor(line("."), l:colsave)
  end
endfunction " }}}

noremap <silent> Dj :call DelEmptyLineBelow()<CR>
noremap <silent> Dk :call DelEmptyLineAbove()<CR>
noremap <silent> Aj :call AddEmptyLineBelow()<CR>
noremap <silent> Ak :call AddEmptyLineAbove()<CR>
" }}}

" }}}

"===========
" Plugin {{{
"===========

"---------------
" vim-toggle {{{
"---------------

nmap - <Plug>ToggleN
" }}}

"------------------
" vim-smartword {{{
"------------------

map w <Plug>(smartword-w)
map b <Plug>(smartword-b)
map e <Plug>(smartword-e)
map ge <Plug>(smartword-ge)
" }}}

"----------------
" matchit.vim {{{
"----------------

runtime macros/matchit.vim
" }}}

"------------
" caw.vim {{{
"------------

nmap gcc <Plug>(caw:wrap:toggle)
" }}}

"-----------------
" vimfiler.vim {{{
"-----------------

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_split_action = "split"
let g:vimfiler_time_format = "%Y/%m/%d %H:%M"

nnoremap <silent> <leader>a :<C-U>VimFiler<CR>
" }}}

"--------------
" unite.vim {{{
"--------------

" unite-variables
let g:unite_split_rule = 'botright'
let g:unite_enable_split_vertically = 1
let g:unite_winwidth = 60

" unite-source-variables
let g:unite_source_file_mru_time_format = '(%F %R)'
let g:unite_source_grep_max_candidates = 1000

nnoremap <SID>[unite] <Nop>
xnoremap <SID>[unite] <Nop>
nmap f <SID>[unite]
xmap f <SID>[unite]

nnoremap <SID>[unite-no-quite] <Nop>
xnoremap <SID>[unite-no-quite] <Nop>
nmap F <SID>[unite-no-quite]
xmap F <SID>[unite-no-quite]

nnoremap <silent> <SID>[unite]F :<C-U>Unite -buffer-name=files bookmark file_mru file<CR>
nnoremap <silent> <SID>[unite]f :<C-U>Unite -buffer-name=files file<CR>
nnoremap <silent> <SID>[unite]b :<C-U>Unite -buffer-name=buffer buffer<CR>
nnoremap <silent> <SID>[unite]r :<C-U>Unite -buffer-name=register register<CR>
nnoremap <silent> <SID>[unite]t :<C-U>Unite -buffer-name=tab tab<CR>
nnoremap <silent> <SID>[unite]o :<C-U>Unite -buffer-name=outline outline<CR>
nnoremap <silent> <SID>[unite]m :<C-U>Unite -buffer-name=mark mark<CR>
nnoremap <silent> <SID>[unite]h :<C-U>Unite -buffer-name=help help<CR>

nnoremap <silent> <SID>[unite-no-quite]F :<C-U>Unite -no-quite -buffer-name=files bookmark file_mru file<CR>
nnoremap <silent> <SID>[unite-no-quite]f :<C-U>Unite -no-quite -buffer-name=files file<CR>
nnoremap <silent> <SID>[unite-no-quite]b :<C-U>Unite -no-quite -buffer-name=buffer buffer<CR>
nnoremap <silent> <SID>[unite-no-quite]r :<C-U>Unite -no-quite -buffer-name=register register<CR>
nnoremap <silent> <SID>[unite-no-quite]t :<C-U>Unite -no-quite -buffer-name=tab tab<CR>
nnoremap <silent> <SID>[unite-no-quite]o :<C-U>Unite -no-quite -buffer-name=outline outline<CR>
nnoremap <silent> <SID>[unite-no-quite]m :<C-U>Unite -no-quite -buffer-name=mark mark<CR>
nnoremap <silent> <SID>[unite-no-quite]h :<C-U>Unite -no-quite -buffer-name=help help<CR>

nnoremap <silent> <leader>b :<C-U>UniteBookmarkAdd<CR>
" }}}

"---------
" altr {{{
"---------

nmap <Leader>n  <Plug>(altr-forward)
nmap <Leader>p  <Plug>(altr-back)
" }}}

"---------------
" unite-neco {{{
"---------------

let s:unite_source = {'name': 'neco'}

function! s:unite_source.gather_candidates(args, context)
  let necos = [
        \ "~(-'_'-) goes right",
        \ "~(-'_'-) goes right and left",
        \ "~(-'_'-) goes right quickly",
        \ "~(-'_'-) goes right then smile",
        \ "~(-'_'-)  -8(*'_'*) go right and left",
        \ "(=' .' ) ~w",
        \ ]
  return map(necos, '{
        \ "word": v:val,
        \ "source": "neco",
        \ "kind": "command",
        \ "action__command": "Neco " . v:key,
        \ }')
endfunction
call unite#define_source(s:unite_source)
" }}}

"---------------
" rsense.vim {{{
"---------------

let g:rsenseHome = expand('$RSENSE_HOME')
let g:rsenseUseOmniFunc = 1
" }}}

"-------------
" vimshell {{{
"-------------

let g:vimshell_prompt = '$ '
let g:vimshell_user_prompt = '"[" . getcwd() ."]"'
" }}}

"----------------------
" neocomplcache.vim {{{
"----------------------

" for rsense.vim {{{
if !exists('g:neocomplcache_omni_patterns')
let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
" }}}

let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_ignore_case = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_snippets_dir = '~/.vim/snippets'
let g:neocomplcache_enable_cursor_hold_i = 1
let g:neocomplcache_enable_auto_delimiter = 1
let g:neocomplcache_max_filename_width = 50

nnoremap <silent> <leader>.s :<C-U>NeoComplCacheEditSnippets<CR>
imap <expr><C-O> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : "\<C-N>"
imap <expr><C-C>  neocomplcache#complete_common_string()
" }}}

"------------
" vim-ref {{{
"------------

if s:iswin
  let g:ref_pydoc_cmd = 'pydoc.bat'
  let g:ref_refe_encoding = 'cp932'
else
  let g:ref_refe_encoding = 'euc-jp'
endif

let g:ref_detect_filetype = {
      \ 'c': 'man', 'clojure': 'clojure', 'perl': 'perldoc', 'php': 'phpmanual', 'ruby': 'refe', 'erlang': 'erlang', 'python': 'pydoc'
      \}

MyAutocmd FileType ref call s:initialize_ref_viewer()
function! s:initialize_ref_viewer()
  nmap <buffer> <Backspace> <Plug>(ref-back)
  nmap <buffer> <S-Backspace> <Plug>(ref-forward)
  setlocal nonumber
endfunction
" }}}

"------------------
" changelog.vim {{{
"------------------

MyAutocmd BufNewFile,BufRead *.changelog setf changelog
let g:changelog_timeformat = "%Y-%m-%d"
let g:changelog_username = "Hideki Hamada (jakalada)"
" }}}

"-----------------
" surround.vim {{{
"-----------------

nmap s ys
nmap S yS
nmap ss yss
nmap SS ySS

inoremap <expr> > smartchr#one_of(' => ', ' >> ', '>')
inoremap <expr> { smartchr#one_of('{}', '{')
inoremap <expr> [ smartchr#one_of('[]', '[')
inoremap <expr> < smartchr#one_of('<>', '<')
inoremap <expr> ( smartchr#one_of('()', '(')
MyAutocmd FileType ruby inoremap <buffer> <expr> = smartchr#one_of('#{}', '# ', '#')
" }}}

"-----------------
" quickrun.vim {{{
"-----------------

let g:quickrun_config = {}
let g:quickrun_config['markdown'] = {
\ 'command': 'kramdown',
\ 'exec': '%c %s'
\ }
" }}}

"-----------------
" vim-fugitive {{{
"-----------------

nnoremap <SID>[fugitive] <Nop>
xnoremap <SID>[fugitive] <Nop>
nmap <Leader>g <SID>[fugitive]
xmap <Leader>g <SID>[fugitive]

nmap <silent> <SID>[fugitive]g <SID>(command-line-enter)Git<Space>
nnoremap <silent> <SID>[fugitive]d :<C-u>Gdiff<Enter>
nnoremap <silent> <SID>[fugitive]s :<C-u>Gstatus<Enter>
nnoremap <silent> <SID>[fugitive]l :<C-u>Glog<Enter>
nnoremap <silent> <SID>[fugitive]a :<C-u>Gwrite<Enter>
nnoremap <silent> <SID>[fugitive]c :<C-u>Gcommit<Enter>
nnoremap <silent> <SID>[fugitive]C :<C-u>Git commit --amend<Enter>
nnoremap <silent> <SID>[fugitive]b :<C-u>Gblame<Enter>
" }}}

"-----------------------
" vim-coffee-script  {{{
"-----------------------

augroup MyCoffeeScriptAutoMake
    autocmd!
augroup END

command!
\   -bang -nargs=*
\   ToggleCoffeeScriptAutoMake
\   call s:toggle_coffee_script_auto_make()


let g:my_coffee_script_auto_make = 0
function! s:toggle_coffee_script_auto_make()
  if g:my_coffee_script_auto_make == 1
    augroup MyCoffeeScriptAutoMake
        autocmd!
    augroup END
    let g:my_coffee_script_auto_make = 0
  else
    autocmd MyCoffeeScriptAutoMake BufWritePost *.coffee silent CoffeeMake!
    let g:my_coffee_script_auto_make = 1
  endif
endfunction
" }}}

"----------------------
" open-browser.vim  {{{
"----------------------
if !exists('g:openbrowser_open_commands')
  let g:openbrowser_open_commands = ['google-chrome', 'firefox']
endif

if !exists('g:openbrowser_open_rules')
  let g:openbrowser_open_rules = {
        \ 'google-chrome': '{browser} {shellescape(uri)}',
        \ 'firefox': '{browser} {shellescape(uri)}',
        \ }
endif

if !exists('g:openbrowser_search_engines')
    let g:openbrowser_search_engines = {
    \   'google': 'http://google.co.jp/search?q={query}',
    \}
endif

nmap <Leader>o <Plug>(openbrowser-smart-search)
vmap <Leader>o <Plug>(openbrowser-smart-search)
" }}}

"--------------
" eskk.vim  {{{
"--------------

" let g:eskk#large_dictionary = {
"       \ 'path': '~/.dict/SKK-JISYO.L',
"       \ 'sorted': 0,
"       \ 'encoding': 'euc-jp'
"       \}
" let g:eskk#show_candidates_count = 1
" let g:eskk#kakutei_when_unique_candidate = 1
" let g:eskk#dictionary_save_count = 1
" 
" let g:eskk#marker_henkan = '_'
" let g:eskk#marker_henkan_select = '?'
" let g:eskk#marker_jisyo_touroku = '#'
" 
" MyAutocmd User eskk-initialize-pre call s:eskk_initial_pre()
" function! s:eskk_initial_pre()
"     " User can be allowed to modify
"     " eskk global variables (`g:eskk#...`)
"     " until `User eskk-initialize-pre` event.
"     " So user can do something heavy process here.
"     " (I'm a paranoia, eskk#table#new() is not so heavy.
"     " But it loads autoload/vice.vim recursively)
"   let t = eskk#table#new('rom_to_hira*', 'rom_to_hira')
"   call t.add_map('z~', '〜')
"   call t.add_map('va', 'ゔぁ')
"   call t.add_map('vi', 'ゔぃ')
"   call t.add_map('vu', 'ゔ')
"   call t.add_map('ve', 'ゔぇ')
"   call t.add_map('vo', 'ゔぉ')
"   call t.add_map('z ', '　')
"   call eskk#register_mode_table('hira', t)
" endfunction
" }}}

" }}}

" }}}

set secure  " must be written at the last.  see :help 'secure'.
