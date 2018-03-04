set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
"To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

"" lifthrasiir's .vimrc file (r16, 2007-07-29)
"" written by Kang Seonghoon <lifthrasiir@gmail.com>
"" This file is placed in the public domain.
"" =========================================================

" UTILITY FUNCTIONS {{{ ------------------------------------
" maps key to the command in insert, normal, and (if vmap=1) visual mode
fu! s:Map(key, value, vmap)
	exe 'imap <silent> ' . a:key . ' <C-\><C-O>' . a:value
	exe 'nmap <silent> ' . a:key . ' ' . a:value
	if a:vmap | exe 'vmap <silent> ' . a:key . ' <Esc>' . a:value . 'gv' | endif
endf

" maps two keys to the command if needed. used for mac's Command key
fu! s:Map2(key1, key2, value, vmap)
	call s:Map(a:key1, a:value, a:vmap)
	if has("macunix") | call s:Map(a:key2, a:value, a:vmap) | endif
endf

" maps key to the function
fu! s:MapFunc(key, fname, vmap)
	call s:Map(a:key, ':call <SID>' . a:fname . '()<CR>', a:vmap)
endf
" }}} ------------------------------------------------------

" TERMINAL {{{ ---------------------------------------------
if &term =~ "xterm"
	set t_Co=256
	colorscheme desert256
	if has("terminfo")
		let &t_Sf = "\<Esc>[3%p1%dm"
		let &t_Sb = "\<Esc>[4%p1%dm"
	else
		let &t_Sf = "\<Esc>[3%dm"
		let &t_Sb = "\<Esc>[4%dm"
	endif
endif

" terminal encoding (always use utf-8 if possible)
if !has("win32") || has("gui_running")
	set enc=utf-8 tenc=utf-8
	if has("win32")
		set tenc=cp949
		let $LANG = substitute($LANG, '\(\.[^.]\+\)\?$', '.utf-8', '')
	endif
endif
if &enc ==? "euc-kr"
	set enc=cp949
endif
" }}} ------------------------------------------------------

" EDITOR {{{ -----------------------------------------------
set nu ru sc wrap ls=2 lz                " -- appearance
set bs=2 ts=2 sw=2 sts=0            " -- tabstop
set expandtab
set noai nosi hls is ic cf ws scs magic  " -- search
set sol sel=inclusive mps+=<:>           " -- moving around
set ut=10 uc=200                         " -- swap control
set report=0 lpl wmnu                    " -- misc.

" encoding and file format
set fenc=utf-8 ff=unix ffs=unix,dos,mac
set fencs=utf-8,cp949,cp932,euc-jp,shift-jis,big5,latin2,ucs2-le

" list mode
set nolist lcs=extends:>,precedes:<
if &tenc ==? "utf-8"
	set lcs+=tab:»\ ,trail:·
else
	set lcs+=tab:\|\ 
endif
" }}} ------------------------------------------------------

" TEMPORARY/BACKUP DIRECTORY {{{ ---------------------------
set swf nobk bex=.bak
if exists("$HOME")
	" makes various files written into ~/.vim/ or ~/_vim/
	let s:home_dir = substitute($HOME, '[/\\]$', '', '')
	if has("win32")
		let s:home_dir = s:home_dir . '/_vim'
	else
		let s:home_dir = s:home_dir . '/.vim'
	endif
	if isdirectory(s:home_dir)
		let &dir = s:home_dir . '/tmp,' . &dir
		let &bdir = s:home_dir . '/backup,' . &bdir
		let &vi = &vi . ',n' . s:home_dir . '/viminfo'
	endif
endif
" }}} ------------------------------------------------------

" KEY MAPPING {{{ ------------------------------------------
set wak=no                          " -- no alt menu mapping
set noto ttimeout tm=3000 ttm=100   " -- input timeout
let mapleader = '\'

" moving around and editing
map <MiddleMouse> <Nop>
map! <MiddleMouse> <Nop>
vmap <Tab> >gv
vmap <S-Tab> <gv
fu! s:HomeKey() " -- home key correction
	let l:column = col('.') | exe "norm ^"
	if l:column == col('.') | exe "norm 0" | endif
endf
call s:MapFunc('<Home>', 'HomeKey', 0)

" switching around buffer
map <F11> :bn<CR>
map <F12> :bN<CR>
if has("macunix")
	map <D-F11> :bn<CR>
	map <D-F12> :bN<CR>
endif

" make search appears in the middle of the screen
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

" immediate buffer configuration
map <silent> <Leader>n :let &nu = 1 - &nu<CR>
map <silent> <Leader>l :let &list = 1 - &list<CR>
map <silent> <Leader>p :let &paste = 1 - &paste<CR>
map <silent> <Leader>w :let &wrap = 1 - &wrap<CR>
nmap <silent> <Leader>4 :set ts=4 sw=4<CR>
nmap <silent> <Leader>8 :set ts=8 sw=8<CR>

" editing and applying .vimrc
if has("win32")
	nmap <silent> <Leader>R :so $HOME/_vimrc<CR>
	nmap <silent> <Leader>rc :e $HOME/_vimrc<CR>
else
	nmap <silent> <Leader>R :so $HOME/.vimrc<CR>
	nmap <silent> <Leader>rc :e $HOME/.vimrc<CR>
endif

" inserting matching quotes
fu! s:InputQuotes()
	if mode() == "R"
		exe "normal \<Esc>" | return ""   " -- beep
	elseif match(getline("."), '\%u2018\%'.col('.').'c\%u2019') < 0
		return "\u2018\u2019\<Insert>\<BS>\<Insert>"
	else
		return "\<Del>\<BS>\u201c\u201d\<Insert>\<BS>\<Insert>"
	endif
endf
imap <silent> <C-'> <C-R>=<SID>InputQuotes()<CR>

" misc. mapping
nmap <silent> <Leader>cd :cd %:p:h<CR>
nmap <silent> <Leader><Space> :noh<CR>
" }}} ------------------------------------------------------

" GUI {{{ --------------------------------------------------
if has("gui_running")
	set go+=c go-=t go-=m go-=T sel=inclusive
	set lines=40 co=100 lsp=0
	set mouse=a  " --TODO
	colo desert

	" font fix
	if has("win32")
		silent! set gfn=Raize:h10 gfw=DotumChe:h11 lsp=-1
	elseif has("macunix")
		silent! set macatsui gfn=Monaco:h12 gfw=AppleGothic\ Regular:h13
	endif

	" toggle menubar
	fu! s:MenuBar()
		if stridx(&go, 'm') == -1
			set go+=T go+=m
		else
			set go-=T go-=m
		endif
	endf
	call s:MapFunc('<M-F10>', 'MenuBar', 1)

	" toggle smaller and bigger font
	let s:fontenlarged = 0
	fu! s:FontSize()
		if s:fontenlarged
			let &gfn = substitute(&gfn, '\(:h\)\@<=\d\+', '\=submatch(0)/2', 'g')
			let &gfw = substitute(&gfw, '\(:h\)\@<=\d\+', '\=submatch(0)/2', 'g')
			exe ':winp ' . s:oldwinposx . ' ' . s:oldwinposy
			let &lines = s:oldlines | let &columns = s:oldcolumns
		else
			let s:oldwinposx = getwinposx() | let s:oldwinposy = getwinposy()
			let s:oldlines = &lines | let s:oldcolumns = &columns
			let &gfn = substitute(&gfn, '\(:h\)\@<=\d\+', '\=submatch(0)*2', 'g')
			let &gfw = substitute(&gfw, '\(:h\)\@<=\d\+', '\=submatch(0)*2', 'g')
		endif
		let s:fontenlarged = 1 - s:fontenlarged
	endf
	map <silent> <Leader>f :call <SID>FontSize()<CR>

	" launching console
	if has("win32")
		fu! s:Console(path)
			let l:path = iconv(a:path, &enc, &tenc)
			silent exe "! start /d \"" . a:path . "\""
		endf
	elseif has("macunix")
		fu! s:Console(path)
			let l:path = iconv(a:path, &enc, &tenc)
			silent exe "!open -a iTerm . && osascript -e 'tell application " .
				\ "\"iTerm\" to tell the last terminal to tell current sess" .
				\ "ion to write text \"cd '\\''" . a:path . "'\\''; clear\"'"
		endf
	else
		fu! s:Console(path)
			echoerr ".vimrc: " . mapleader . "C is not enabled here."
		endf
	endif
	nmap <silent> <Leader>C :call <SID>Console(expand("%:p:h"))<CR>
else
	" update terminal title
	set title titlestring=%{$USER}@%{hostname()}:\ %F\ (%l/%L)\ -\ VIM
endif

" share vim's own clipboard with system clipboard
if has("gui_running") || has("xterm_clipboard")
	set cb=unnamed
endif
" }}} ------------------------------------------------------

" SYNTAX {{{ -----------------------------------------------
syn enable
syn sync maxlines=1000
filet plugin indent on
let php_sync_method = 0
let html_wrong_comments = 1
" }}} ------------------------------------------------------

" AUTOCMD {{{ ----------------------------------------------
if 1
	aug vimrc
	au!

	" filetype-specific configurations
  au FileType python setl et ts=4 sw=4 sts=4
	au FileType html setl ts=4 sw=4 sts=4 et
	au FileType css setl ts=4 sw=4 sts=4 et
	au FileType php setl ts=4 sw=4 sts=4 et
	au Filetype text setl tw=80
	au FileType javascript,jsp setl cin
	au BufNewFile,BufRead *.phps,*.php3s setf php

	" restore cursor position when the file has been read
	au BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\   exe "norm g`\"" |
		\ endif

	" fix window position for mac os x
	if has("gui_running") && has("macunix")
		au GUIEnter *
			\ if getwinposx() < 50 |
			\   exe ':winp 50 ' . (getwinposy() + 22) |
			\ endif
	endif

	" fix window size if window size has been changed
	if has("gui_running")
		fu! s:ResizeWindows()
			let l:nwins = winnr("$") | let l:num = 1
			let l:curtop = 0 | let l:curleft = 0
			let l:lines = &lines - &cmdheight
			let l:prevlines = s:prevlines - &cmdheight
			let l:cmd = ""
			while l:num < l:nwins
				if l:curleft == 0
					let l:adjtop = l:curtop * l:lines / l:prevlines
					let l:curtop = l:curtop + winheight(l:num) + 1
					if l:curtop < l:lines
						let l:adjheight = l:curtop * l:lines / l:prevlines - l:adjtop - 1
						let l:cmd = l:cmd . l:num . "resize " . l:adjheight . "|"
					endif
				endif
				let l:adjleft = l:curleft * &columns / s:prevcolumns
				let l:curleft = l:curleft + winwidth(l:num) + 1
				if l:curleft < &columns
					let l:adjwidth = l:curleft * &columns / s:prevcolumns - l:adjleft - 1
					let l:cmd = l:cmd . "vert " . l:num . "resize " . l:adjwidth . "|"
				else
					let l:curleft = 0
				endif
				let l:num = l:num + 1
			endw
			exe l:cmd
		endf
		fu! s:ResizeAllWindows()
			if v:version >= 700
				let l:tabnum = tabpagenr()
				tabdo call s:ResizeWindows()
				exe "norm " . l:tabnum . "gt"
			else
				call s:ResizeWindows()
			endif
			let s:prevlines = &lines | let s:prevcolumns = &columns
		endf
		au GUIEnter * let s:prevlines = &lines | let s:prevcolumns = &columns
		au VimResized * call s:ResizeAllWindows()
	endif

	aug END
endif
" }}} ------------------------------------------------------

" VIM7 SPECIFIC {{{ ----------------------------------------
if v:version >= 700
	" editor setting
	set nuw=6
	
	" omni completition
	set ofu=syntaxcomplete#Complete
	imap <C-Space> <C-X><C-N>

	" key mapping for tabpage
	call s:Map2('<C-Tab>', '<D-Down>', 'gt', 0)
	call s:Map2('<C-S-Tab>', '<D-Up>', 'gT', 0)
	let i = 1
	while i <= 10
		call s:Map2('<M-' . (i % 10) . '>', '<D-' . (i % 10) . '>', i . 'gt', 0)
		let i = i + 1
	endw
	call s:Map2('<M-n>', '<D-n>', ':tabnew<CR>', 0)
	call s:Map2('<M-w>', '<D-w>', ':tabclose<CR>', 0)
endif
" }}} ------------------------------------------------------

" end of configuration
finish

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CHANGELOGS:
" 2005-10-13  initial revision
" 2005-12-18  added various settings from barosl's .vimrc
"             set custom temporary directory
"             synchronized system clipboard with vim register
" 2006-01-24  maps euc-kr encoding to cp949
" 2006-05-11  added fold marker and home key correction
"             ignores error when the font doesn't exist
"             added shortcut for vim7 tabpage
" 2006-05-12  explicit <Leader> mapping
"             added some utility functions and \R, \rc, \cd
"             removed redundant menubars (toggle with M-F10)
"             added support for vim7 omni completition
" 2006-06-17  added \w, \4 and \8, \f shortcut
" 2006-07-03  changed win32 terminal encoding to utf-8
"             uses bigger DotumChe for wide font
" 2006-08-11  made search appears in the middle of the screen
"             added shiftwidth option to \4 and \8
" 2006-08-13  added \C shortcut for win32 console
" 2006-09-07  set html_wrong_comments for invalid HTMLs
" 2006-10-08  fixed minor bug of \8 (wrong shiftwidth)
" 2007-03-19  fixed bugs on non-win32 platforms
" 2007-05-28  added support for mac os x (font setting, etc)
" 2007-06-16  merged r12 (2007-03-19) and r13 (2007-05-28)
"             added more comments and changelogs (finally!)
"             changed overall structure of the script
"             added \C command for mac os x
" 2007-07-03  adds <D-..> only in mac os x (failed otherwise)
"             got \f shortcut working in non-win32 platforms
" 2007-07-29  adds \<Space>, <C-'> shortcuts; changed ffs order
"             fixed \C bug and window disposition in mac os x
"             automatic proportional resizing of windows
"
" TODOS:
" - integrated ctags support
" - more filetype-specific configuration
" - <![CDATA[]]> block on html syntax
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

