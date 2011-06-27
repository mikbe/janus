" This file should be for stuff you *DO NOT* change often and *WILL NOT* reload
set nocompatible
autocmd!

" I don't know why this is off...
filetype off

" Pathogen need to be right up at the top
call pathogen#runtime_append_all_bundles("janus_bundle")
call pathogen#helptags()
filetype plugin indent on

" Don't warn if switching from an unsaved buffer (annoying!)
set hidden
set number
set ruler
syntax on

" Set encoding
set encoding=utf-8

" Whitespace stuff
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set list listchars=tab:\ \ ,trail:·

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

" Status bar
set laststatus=2

" Without setting this, ZoomWin restores windows in a way that causes
" equalalways behavior to be triggered the next time CommandT is used.
" This is likely a bludgeon to solve some other issue, but it works
set noequalalways

" NERDTree configuration
let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']

" Command-T configuration
let g:CommandTMaxHeight=20

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

function! s:setupWrapping()
  set wrap
  set wrapmargin=2
  set textwidth=72
endfunction

function! s:setupMarkup()
  call s:setupWrapping()
endfunction

" make uses real tabs
au FileType make set noexpandtab

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

" add json syntax highlighting
au BufNewFile,BufRead *.json set ft=javascript

au BufRead,BufNewFile *.txt call s:setupWrapping()

" make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Enable syntastic syntax checking
let g:syntastic_enable_signs=1
let g:syntastic_quiet_warnings=1

" gist-vim defaults
if has("mac")
  let g:gist_clip_command = 'pbcopy'
elseif has("unix")
  let g:gist_clip_command = 'xclip -selection clipboard'
endif
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

" Use modeline overrides
set modeline
set modelines=10

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" Turn off jslint errors by default
let g:JSLintHighlightErrorLine = 0

" MacVIM shift+arrow-keys behavior (required in .vimrc)
let macvim_hig_shift_movement = 1

" % to bounce from do to end etc.
runtime! macros/matchit.vim

" Show (partial) command in the status line
set showcmd
let PechoLock = 0
fu! Pecho(msg)
  wh islocked("g:PechoLock")|sl|endw
  lockv g:PechoLock|let s:hold_ut=&ut|let &ut=1
  let s:Pecho=a:msg
  aug Pecho
    au CursorHold * ec s:Pecho
          \|let &ut=s:hold_ut|unlo g:PechoLock
          \|aug Pecho|exe 'au!'|aug END|aug! Pecho
  aug END
endf

" show (partial) command in the status line
set showcmd

" Automatically reload the vimrc.local file after it's saved
if has("autocmd")
  autocmd! BufWritePost .vimrc.local,vimrc.local call LoadLocal()
endif

" Allows the last thing echoed to be visible without annoying
" "Press Enter to Continue" messages.
let PechoLock = 0
fu! s:Pecho(msg)
  wh islocked("g:PechoLock")|sl|endw
  lockv g:PechoLock|let s:hold_ut=&ut|let &ut=1
  let s:Pecho=a:msg
  aug Pecho
    au CursorHold * ec s:Pecho
          \|let &ut=s:hold_ut|unlo g:PechoLock
          \|aug Pecho|exe 'au!'|aug END|aug! Pecho
  aug END
endf

" Load the vimrc.local file if there is one
function! LoadLocal()
  if filereadable(expand("~/.vimrc.local"))
    source $MYVIMRC.local
    call s:Pecho("Reloaded: " . strftime("%H:%M:%S"))
  endif
endfunction
call LoadLocal()

