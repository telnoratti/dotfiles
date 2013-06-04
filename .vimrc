:filetype plugin on

colorscheme sunburst
syntax enable
set nu

noremap H ^
noremap L $

set expandtab
set softtabstop=4
set smartindent
set autoindent
set shiftwidth=4

let python_highlight_all=1

:map <F5> :setlocal spell! spelllang=en_us<CR>
:imap <F5> <C-o>:setlocal spell! spelllang=en_us<CR>

:map <F3> :setlocal nosmartindent noautoindent nonu<CR>
:map <F4> :setlocal smartindent autoindent nu<CR>

