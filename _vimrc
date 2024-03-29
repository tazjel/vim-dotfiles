" jakalada's vimrc

" =============================================
" SECTION: Initialize {{{1
" =============================================

" .vimrcの再読み込み時にオプションを初期化する {{{
" 設定されたruntimepathが初期化されないようにする
let s:tmp = &runtimepath
set all&
let &runtimepath = s:tmp
unlet s:tmp
" }}}

" featureの状態を取得 {{{
let s:iswin32 = has('win32')
let s:iswin64 = has('win64')
let s:iswin = has('win32') || has('win64')

let s:isgui = has("gui_running")

let s:ismacunix = has("macunix")
" }}}

" vimで扱うディレクトリのパスを設定 {{{
if s:iswin
  " For Windows {{{
  " すでに読み込まれているファイル名には影響がないので注意する
  set shellslash

  let $DOTVIMDIR = expand('~/vimfiles')

  let $DROPBOXDIR = expand('~/Dropbox')

  let $VIMCONFIGDIR = expand('~/project/vim-dotfiles')
  " }}}
else
  " For Linux {{{
  let $DOTVIMDIR = expand('~/.vim')

  let $DROPBOXDIR = expand('~/Dropbox')

  let $VIMCONFIGDIR = expand('~/project/vim-dotfiles')
  " }}}
endif
" }}}

" pathogen.vim {{{
filetype off

call pathogen#infect()
call pathogen#helptags()

filetype on
filetype plugin on
filetype indent on
" }}}

" singleton.vim {{{
"call singleton#enable()
" }}}

" =============================================
" SECTION: Commands {{{1
" =============================================

" .vimrcの再読み込み時に.vimrc内で設定されたautocmdを初期化する {{{
" MyAutocmdを使用することで漏れなく初期化できる
augroup vimrc
    autocmd!
augroup END

command!
\   -bang -nargs=*
\   MyAutocmd
\   autocmd<bang> vimrc <args>
" }}}

" 定義されているマッピングを調べるコマンドを定義する {{{
command!
\   -nargs=* -complete=mapping
\   AllMaps
\   map <args> | map! <args> | lmap <args>
" }}}

" For rails.vim {{{
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

" =============================================
" SECTION: Functions {{{1
" =============================================

" =============================================
" SECTION: Encoding {{{1
" =============================================

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

" =============================================
" SECTION: Syntax {{{1
" =============================================

syntax enable

MyAutocmd BufWinEnter,BufNewFile *_spec.rb set filetype=ruby.rspec
MyAutocmd BufWinEnter,BufNewFile *_spec.coffee set filetype=coffee.jasmine
MyAutocmd BufWinEnter,BufNewFile *_spec.coffee set filetype=coffee.vows

" ft-ruby-syntax
let ruby_operators = 1

" NOTE: ファイルタイプがvimのときでも`set foldmethod=syntax`されてしまう
" let ruby_fold = 1

let ruby_no_comment_fold = 1
" let g:rubycomplete_buffer_loading = 1
" let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

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

" =============================================
" SECTION: Options {{{1
" =============================================

if s:isgui
  colorscheme hickop

  if s:ismacunix
    set guifont=Osaka-Mono:h18
  elseif s:iswin
    set guifont=Ricty\ Discord\ 13.5
  else
    set guifont=Ricty\ Discord\ 13.5
  endif

  set guioptions=aciM
  set mouse=a
  set mousehide
  set mousefocus
  set novisualbell
  set guicursor+=a:blinkon0
  let loaded_matchparen = 1
else
  set t_Co=256
  colorscheme distinguished
endif

set pumheight=10

set nocursorline
set cmdheight=2

set autoindent
set smartindent

set smarttab
set expandtab
set softtabstop=2

set shiftwidth=2
set shiftround

set backspace=indent,eol,start

set nojoinspaces

setlocal matchpairs+=<:>

setlocal iskeyword+=-

set hidden

set directory-=.
if v:version >= 703
  set undofile
  let &undodir=&directory
endif

if has('virtualedit')
  set virtualedit=block,insert
endif

" TODO: ヘルプでオプションの詳細を確認してカスタマイズ
set formatoptions+=mM

set scrolloff=10

set helplang=ja

MyAutocmd WinEnter * checktime
set autoread

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
set hlsearch

nnoremap <silent> <SID>[nohlsearch] :<C-U>nohlsearch<CR>

nnoremap <script> / <SID>[nohlsearch]/
nnoremap <script> ? <SID>[nohlsearch]?

nnoremap <script> v <SID>[nohlsearch]v
nnoremap <script> <C-V> <SID>[nohlsearch]<C-V>
nnoremap <script> V <SID>[nohlsearch]V

nnoremap <script> i <SID>[nohlsearch]i
nnoremap <script> I <SID>[nohlsearch]I

nnoremap <script> a <SID>[nohlsearch]a
nnoremap <script> A <SID>[nohlsearch]A

nnoremap <script> o <SID>[nohlsearch]o
nnoremap <script> O <SID>[nohlsearch]O
" }}}

set linespace=3

set number

set noshowcmd

set noshowmode

set confirm

set report=0

set noequalalways

if has('conceal')
  set conceallevel=2
endif

set list
set listchars=tab:>-,trail:-

set fillchars=vert:\ ,fold:\ ,diff:\ 

set showbreak=↪

set wrap

set textwidth=0

set laststatus=2

set nomodeline

set foldopen=block,quickfix,search,tag,undo

" =============================================
" SECTION: Key-mappings {{{1
" =============================================

" NOTE: IBusで日本語入力に切り替えるたびにスペースが挿入されてしまう
noremap <C-Space> <Nop>
noremap! <C-Space> <Nop>
xnoremap <C-Space> <Nop>
snoremap <C-Space> <Nop>
lnoremap <C-Space> <Nop>

noremap <C-J> <Esc>
inoremap <C-J> <Esc>
cnoremap <C-J> <C-C>
xnoremap <C-J> <Esc>
snoremap <C-J> <Esc>
lnoremap <C-J> <Esc>

noremap <C-K> <Esc>
inoremap <C-K> <Esc>l
cnoremap <C-K> <C-C>
xnoremap <C-K> <Esc>
snoremap <C-K> <Esc>
lnoremap <C-K> <Esc>

" ---------------------------------------------
" Leader {{{2
" ---------------------------------------------

let mapleader = ' '
let g:mapleader = ' '
let g:maplocalleader = '\'

nnoremap <Space> <Nop>
xnoremap <Space> <Nop>
nnoremap \ <Nop>
xnoremap \ <Nop>

" ---------------------------------------------
" mapmode-nvo {{{2
" ---------------------------------------------

noremap j gj
noremap k gk

noremap L g_
noremap H ^

noremap <C-H> <C-U>
noremap <C-L> <C-D>

" ---------------------------------------------
" mapmode-n {{{2
" ---------------------------------------------
nnoremap <Leader>k <C-^>

nnoremap <Backspace> <C-O>
nnoremap <S-Backspace> <C-I>

nnoremap <silent> <leader><leader> :<C-U>write<CR>

nnoremap <C-Up> <C-A>
nnoremap <C-Down> <C-X>

nnoremap Q q
nnoremap <silent> q :<C-U>close<CR>

nnoremap <C-Backspace> <C-^>

nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" ---------------------------------------------
" mapmode-i {{{2
" ---------------------------------------------
inoremap <silent> <C-L> <Right>
inoremap <silent> <C-H> <Left>

inoremap <silent> <F7> <Esc>gUiwea

" ---------------------------------------------
" mapmode-ic {{{2
" ---------------------------------------------

" ---------------------------------------------
" mapmode-o {{{2
" ---------------------------------------------

onoremap / t
onoremap ? T

" =============================================
" SECTION: Plugins {{{1
" =============================================

" ---------------------------------------------
" PLUGIN: vim-toggle {{{2
" ---------------------------------------------

nmap - <Plug>ToggleN

" ---------------------------------------------
" PLUGIN: matchit.vim {{{2
" ---------------------------------------------

runtime macros/matchit.vim

" ---------------------------------------------
" PLUGIN: caw.vim {{{2
" ---------------------------------------------

nmap gcc <Plug>(caw:wrap:toggle)

" ---------------------------------------------
" PLUGIN: vimfiler.vim {{{2
" ---------------------------------------------

let g:vimfiler_as_default_explorer = 1

let g:vimfiler_split_action = "split"
let g:vimfiler_time_format = "%Y/%m/%d %H:%M"
let g:unite_kind_file_delete_file_command = 'trash-put $srcs'
let g:unite_kind_file_delete_directory_command = 'trash-put -rf $srcs'

let g:vimfiler_tree_leaf_icon = '  '
let g:vimfiler_tree_opened_icon = ' ▾'
let g:vimfiler_tree_closed_icon = ' ▸'
let g:vimfiler_file_icon = ' -'
let g:vimfiler_marked_file_icon = ' *'

nnoremap <silent> <leader>E :<C-U>VimFiler -buffer-name=explorer -split -simple -winwidth=35 -toggle -no-quite<CR>
nnoremap <silent> <leader>e :<C-U>VimFiler<CR>

" ---------------------------------------------
" PLUGIN: unite.vim {{{2
" ---------------------------------------------

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

nnoremap <silent> <SID>[unite]<Space> :<C-U>UniteResume<CR>

" simple key mappings {{{
nnoremap <silent> <SID>[unite]F :<C-U>Unite -buffer-name=files bookmark directory_mru file_mru<CR>
nnoremap <silent> <SID>[unite]f :<C-U>Unite -buffer-name=files file<CR>
nnoremap <silent> <SID>[unite]b :<C-U>Unite -buffer-name=buffer_tab buffer_tab<CR>
nnoremap <silent> <SID>[unite]B :<C-U>Unite -buffer-name=buffer buffer<CR>
nnoremap <silent> <SID>[unite]r :<C-U>Unite -buffer-name=register register<CR>
nnoremap <silent> <SID>[unite]t :<C-U>Unite -buffer-name=tab tab:no-current<CR>
nnoremap <silent> <SID>[unite]w :<C-U>Unite -buffer-name=window window:no-current<CR>
nnoremap <silent> <SID>[unite]o :<C-U>Unite -buffer-name=outline outline<CR>
nnoremap <silent> <SID>[unite]m :<C-U>Unite -buffer-name=mark mark<CR>
nnoremap <silent> <SID>[unite]h :<C-U>Unite -buffer-name=help help<CR>
nnoremap <silent> <SID>[unite]H :<C-U>Unite -buffer-name=refe -input=ref source<CR>
nnoremap <silent> <SID>[unite]R :<C-U>Unite -buffer-name=rails -input=rails source<CR>
nnoremap <silent> <SID>[unite]s :<C-U>Unite -buffer-name=snippet snippet<CR>
nnoremap <silent> <SID>[unite]S :<C-U>Unite -buffer-name=source source<CR>
nnoremap <silent> <SID>[unite]q :<C-U>Unite -buffer-name=qf qf<CR>

nnoremap <silent> <SID>[unite-no-quite]F :<C-U>Unite -no-quite -keep-focus -buffer-name=files bookmark directory_mru file_mru<CR>
nnoremap <silent> <SID>[unite-no-quite]f :<C-U>Unite -no-quite -keep-focus -buffer-name=files file<CR>
nnoremap <silent> <SID>[unite-no-quite]b :<C-U>Unite -no-quite -keep-focus -buffer-name=buffer_tab buffer_tab<CR>
nnoremap <silent> <SID>[unite-no-quite]B :<C-U>Unite -no-quite -keep-focus -buffer-name=buffer buffer<CR>
nnoremap <silent> <SID>[unite-no-quite]r :<C-U>Unite -no-quite -keep-focus -buffer-name=register register<CR>
nnoremap <silent> <SID>[unite-no-quite]t :<C-U>Unite -no-quite -keep-focus -buffer-name=tab tab:no-current<CR>
nnoremap <silent> <SID>[unite-no-quite]w :<C-U>Unite -no-quite -keep-focus -buffer-name=window window:no-current<CR>
nnoremap <silent> <SID>[unite-no-quite]o :<C-U>Unite -no-quite -keep-focus -buffer-name=outline outline<CR>
nnoremap <silent> <SID>[unite-no-quite]m :<C-U>Unite -no-quite -keep-focus -buffer-name=mark mark<CR>
nnoremap <silent> <SID>[unite-no-quite]h :<C-U>Unite -no-quite -keep-focus -buffer-name=help help<CR>
nnoremap <silent> <SID>[unite-no-quite]H :<C-U>Unite -no-quite -keep-focus -buffer-name=refe -input=ref source<CR>
nnoremap <silent> <SID>[unite-no-quite]R :<C-U>Unite -no-quite -keep-focus -buffer-name=rails -input=rails source<CR>
nnoremap <silent> <SID>[unite-no-quite]s :<C-U>Unite -no-quite -keep-focus -buffer-name=snippet snippet<CR>
nnoremap <silent> <SID>[unite-no-quite]S :<C-U>Unite -no-quite -keep-focus -buffer-name=source source<CR>
nnoremap <silent> <SID>[unite-no-quite]q :<C-U>Unite -no-quite -keep-focus -buffer-name=qf qf<CR>
" }}}

" unite-line " {{{
nnoremap <silent> <SID>[unite]l :<C-U>UniteWithCursorWord -buffer-name=line line<CR>
nnoremap <silent> <SID>[unite-no-quite]l :<C-U>UniteWithCursorWord -no-quite -buffer-name=line line<CR>
" }}}

" unite-menu {{{
let g:unite_source_menu_menus = {}
let g:unite_source_menu_menus.fugitive = {
      \     'description' : 'fugitive menu',
      \ }
let g:unite_source_menu_menus.fugitive.candidates = {
      \       'add'      : 'Gwrite',
      \       'blame'      : 'Gblame',
      \       'diff'      : 'Gdiff',
      \       'commit'      : 'Gcommit',
      \       'status'      : 'Gstatus',
      \       'rm'      : 'Gremove',
      \     }
function g:unite_source_menu_menus.fugitive.map(key, value)
  return {
        \       'word' : a:key, 'kind' : 'command',
        \       'action__command' : a:value,
        \     }
endfunction

nnoremap <silent> <SID>[unite]g :<C-u>Unite menu:fugitive<CR>
" }}}

" ---------------------------------------------
" PLUGIN: altr {{{2
" ---------------------------------------------

nmap <Leader>n  <Plug>(altr-forward)
nmap <Leader>p  <Plug>(altr-back)

call altr#define('spec/%_spec.rb', 'lib/%.rb')
call altr#define('src/lib/*/%.coffee', 'spec/*/%_spec.coffee')
call altr#define('src/lib/%.coffee', 'spec/%_spec.coffee')

" ---------------------------------------------
" PLUGIN: unite-neco {{{2
" ---------------------------------------------

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

" ---------------------------------------------
" PLUGIN: rsense.vim {{{2
" ---------------------------------------------

" let g:rsenseHome = expand('$RSENSE_HOME')
" let g:rsenseUseOmniFunc = 1

" ---------------------------------------------
" PLUGIN: vimshell {{{2
" ---------------------------------------------

let g:vimshell_prompt = '$ '
let g:vimshell_user_prompt = '"[" . getcwd() ."]"'

" ---------------------------------------------
" PLUGIN: neocomplcache.vim {{{2
" ---------------------------------------------

if !exists('g:neocomplcache_dictionary_filetype_lists')
let g:neocomplcache_dictionary_filetype_lists = {
      \ 'jasmine': expand('~/.vim/dict/jasmine.dict'),
      \ 'vows': expand('~/.vim/dict/vows.dict')
      \}
endif

let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_lock_iminsert = 1

inoremap <expr><C-C> neocomplcache#complete_common_string()
inoremap <expr><C-O>  neocomplcache#start_manual_complete()

" ---------------------------------------------
" PLUGIN: neosnippet {{{2
" ---------------------------------------------

let g:neosnippet#snippets_directory = expand('~/.vim/snippets')

nnoremap <silent> <leader>.s :<C-U>NeoSnippetEdit<CR>
imap <expr><TAB> neosnippet#expandable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" ---------------------------------------------
" PLUGIN: vim-ref {{{2
" ---------------------------------------------

if s:iswin
  let g:ref_pydoc_cmd = 'pydoc.bat'
  let g:ref_refe_encoding = 'cp932'
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

" ---------------------------------------------
" PLUGIN: changelog.vim {{{2
" ---------------------------------------------

MyAutocmd BufNewFile,BufRead *.changelog setf changelog
let g:changelog_timeformat = "%Y-%m-%d"
let g:changelog_username = "Hideki Hamada (jakalada)"

" ---------------------------------------------
" PLUGIN: surround.vim {{{2
" ---------------------------------------------

nmap s ys
nmap S yS

nmap ss yss
nmap SS ySS

vmap s S

" ---------------------------------------------
" PLUGIN: quickrun.vim {{{2
" ---------------------------------------------

let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config['ruby.rspec'] = {'command': 'rspec'}
let g:quickrun_config['markdown'] = {
\ 'command': 'kramdown',
\ 'exec': '%c %s'
\ }

" ---------------------------------------------
" PLUGIN: vim-coffee-script {{{2
" ---------------------------------------------

" ---------------------------------------------
" PLUGIN: tagbar  {{{2
" ---------------------------------------------

let g:tagbar_sort = 0

nnoremap <silent> <Leader>t :<C-U>TagbarToggle<CR>

" ---------------------------------------------
" PLUGIN: open-browser.vim  {{{2
" ---------------------------------------------

nmap <Leader>o <Plug>(openbrowser-smart-search)
vmap <Leader>o <Plug>(openbrowser-smart-search)

" ---------------------------------------------
" PLUGIN: Powerline {{{2
" ---------------------------------------------

let g:Powerline_cache_file = ''
if s:isgui
  let g:Powerline_symbols = 'compatible'
else
  " NOTE: Use '* for Poweline' font in terminal.
  "       Read *Powerline-symbols-fancy* in help.
  let g:Powerline_symbols = 'compatible'
endif

" ---------------------------------------------
" PLUGIN: quickhl.vim {{{2
" ---------------------------------------------

nmap <Space>m <Plug>(quickhl-toggle)
xmap <Space>m <Plug>(quickhl-toggle)
nmap <Space>M <Plug>(quickhl-reset)
xmap <Space>M <Plug>(quickhl-reset)
nmap <Space>j <Plug>(quickhl-match)

" =============================================
" SECTION: Misc {{{1
" =============================================

" ---------------------------------------------
" Vimで静的にシンタックスチェックを行なう {{{2
" ---------------------------------------------

" REF: http://d.hatena.ne.jp/osyo-manga/20110921/1316605254

" for vim-hier {{{
highlight qf_error_ucurl gui=underline guifg=yellow guibg=NONE
highlight qf_error_ucurl cterm=underline ctermfg=yellow ctermbg=NONE
let g:hier_highlight_group_qf  = "qf_error_ucurl"
" }}}

" outputter/quickfixをquickrunに登録 {{{
let s:silent_quickfix = quickrun#outputter#quickfix#new()
function! s:silent_quickfix.finish(session)
    call call(quickrun#outputter#quickfix#new().finish, [a:session], self)
    :cclose
    :HierUpdate
    :QuickfixStatusEnable
endfunction
call quickrun#register_outputter("silent_quickfix", s:silent_quickfix)
" }}}

let g:quickrun_config = get(g:, 'quickrun_config', {})

" for ruby {{{
let g:quickrun_config["RubySyntaxCheck_ruby"] = {
    \ "exec"      : "%c %o %s:p ",
    \ "command"   : "ruby",
    \ "cmdopt"    : "-cw",
    \ "outputter" : "silent_quickfix",
    \ "runner"    : "vimproc"
\ }
" }}}

" for c {{{
let g:quickrun_config["CSyntaxCheck_c"] = {
    \ "exec"      : "%c %o %s:p ",
    \ "command"   : "gcc",
    \ "cmdopt"    : "-Wall -Wextra -pedantic -fsyntax-only",
    \ "outputter" : "silent_quickfix",
    \ "runner"    : "vimproc"
\ }
" }}}

function! s:syntax_check_for_filetype()
  let filetypes = split(&filetype, ',')
  if index(filetypes, 'ruby') >= 0
    if expand('%:t') !~# '_steps.rb$'
      execute ':QuickRun RubySyntaxCheck_ruby'
    endif
  elseif index(filetypes, 'c') >= 0
    execute ':QuickRun CSyntaxCheck_c'
  endif
endfunction

MyAutocmd BufWritePost * call s:syntax_check_for_filetype()
MyAutocmd FileType * :HierClear


" ---------------------------------------------
" 折りたたみ {{{2
" ---------------------------------------------

" キーマッピング {{{
nnoremap <SID>[fold] <Nop>
xnoremap <SID>[fold] <Nop>
nmap z <SID>[fold]
xmap z <SID>[fold]

noremap <SID>[fold]g [z
noremap <SID>[fold]G ]z
noremap <SID>[fold]j zj
noremap <SID>[fold]k zk

noremap <SID>[fold]l zo
noremap <SID>[fold]L zO
noremap <SID>[fold]h zc
noremap <SID>[fold]H zC
noremap <SID>[fold]t za
noremap <SID>[fold]T zA

noremap <SID>[fold]M zM
noremap <SID>[fold]m zm
noremap <SID>[fold]R zR
noremap <SID>[fold]r zr
" }}}

" 表示 {{{
set foldtext=getline(v:foldstart)
" }}}

" ---------------------------------------------
" タブページ {{{2
" ---------------------------------------------

" キーバインド {{{
nnoremap <SID>[tab] <Nop>
nmap t <SID>[tab]

nnoremap <SID>[tabnew] <Nop>
nmap T <SID>[tabnew]

nnoremap <silent> <SID>[tab]l :<C-U>tabnext<CR>
nnoremap <silent> <SID>[tab]h :<C-U>tabprev<CR>
nnoremap <silent> <SID>[tab]q :<C-U>tabclose<CR>
nnoremap <silent> <SID>[tab]t :<C-U>tabnew<CR>

nnoremap <silent> <SID>[tabnew]n :<C-U>tabnew \| lcd $DROPBOXDIR/Notes<CR>
nnoremap <silent> <SID>[tabnew]v :<C-U>tabnew \| lcd $VIMCONFIGDIR<CR>
" }}}

" 表示 {{{
" REF: http://d.hatena.ne.jp/thinca/20111204/1322932585
set showtabline=2
set tabline=%!MakeTabLine()

function! s:tabpage_label(n)
  " t:title と言う変数があったらそれを使う
  let title = gettabvar(a:n, 'title')
  if title !=# ''
    return ' #' . title . ' '
  endif

  " タブページ内のバッファのリスト
  let bufnrs = tabpagebuflist(a:n)

  " カレントタブページかどうかでハイライトを切り替える
  let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'

  " タブページ内に変更ありのバッファがあったら '+' を付ける
  let mod = len(filter(copy(bufnrs), 'getbufvar(v:val, "&modified")')) ? ' [+]' : ''

  " カレントバッファ
  let curbufnr = bufnrs[tabpagewinnr(a:n) - 1]  " tabpagewinnr() は 1 origin
  let fname = bufname(curbufnr)
  if fname ==# ''
    let fname = '[No Name]'
  else
    let fname = fnamemodify(fname, ':t')
  end

  let label = mod . ' ' . fname . ' '

  return '%' . a:n . 'T' . hi . label . '%T%#TabLineFill#'
endfunction

function! MakeTabLine()
  let titles = map(range(1, tabpagenr('$')), 's:tabpage_label(v:val)')
  let sep = ' : '
  let tabpages = join(titles, sep) . sep . '%#TabLineFill#%T'
  "let info = '(' . fnamemodify(getcwd(), ':~') . ') ' " 好きな情報を入れる
  let info = ''
  return tabpages . '%=' . info  " タブリストを左に、情報を右に表示
endfunction
" }}}

" ---------------------------------------------
" ウィンドウ {{{2
" ---------------------------------------------

nnoremap <SID>[window] <Nop>
nmap $ <SID>[window]

nnoremap <Tab> <C-W>w
nnoremap <S-Tab> <C-W>W

nmap <SID>[window]j <SID>(split-to-j)
nmap <SID>[window]k <SID>(split-to-k)
nmap <SID>[window]h <SID>(split-to-h)
nmap <SID>[window]l <SID>(split-to-l)

nnoremap <silent> <SID>(split-to-j) :<C-U>execute 'belowright' (v:count == 0 ? '' : v:count) 'split'<CR>
nnoremap <silent> <SID>(split-to-k) :<C-U>execute 'aboveleft'  (v:count == 0 ? '' : v:count) 'split'<CR>
nnoremap <silent> <SID>(split-to-h) :<C-U>execute 'topleft'    (v:count == 0 ? '' : v:count) 'vsplit'<CR>
nnoremap <silent> <SID>(split-to-l) :<C-U>execute 'botright'   (v:count == 0 ? '' : v:count) 'vsplit'<CR>

" ---------------------------------------------
" コマンドラインウィンドウ {{{2
" ---------------------------------------------

nnoremap <silent> <SID>(command-line-enter) q:
xnoremap <silent> <SID>(command-line-enter) q:
nnoremap <silent> <SID>(command-line-enter-help) q:help<Space>

nnoremap ; <Nop>
xnoremap ; <Nop>

nmap ; <SID>(command-line-enter)
xmap ; <SID>(command-line-enter)

nnoremap <leader>h <Nop>

nmap <leader>h <SID>(command-line-enter-help)

MyAutocmd CmdwinEnter * call s:init_cmdwin()
function! s:init_cmdwin() " {{{
  inoremap <expr><CR> pumvisible() ? '<C-Y><CR>' : '<CR>'
  startinsert!
endfunction " }}}

" ---------------------------------------------
" 空行を追加と削除を容易にする {{{2
" ---------------------------------------------

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

" }}}2

" }}}1

set secure  " must be written at the last.  see :help 'secure'.
