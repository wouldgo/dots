""" Automatically create needed files and folders on first run (*nix only) {{{
  call system('mkdir -p $HOME/.vim/{autoload,bundle,swap,undo}')
  if !filereadable($HOME.'/.vimrc.plugins') | call system('touch $HOME/.vimrc.plugins') | endif
  if !filereadable($HOME.'/.vimrc.first') | call system('touch $HOME/.vimrc.first') | endif
  if !filereadable($HOME.'/.vimrc.last') | call system('touch $HOME/.vimrc.last') | endif
""" }}}

""" vim-plug plugin manager {{{
  if empty(glob('~/.vim/autoload/plug.vim'))
    let g:clone_details = 'https://github.com/junegunn/vim-plug.git $HOME/.vim/bundle/vim-plug'
    silent call system('git clone --depth 1 '. g:clone_details)
    if v:shell_error | silent call system('git clone ' . g:clone_details) | endif
    silent !ln -s $HOME/.vim/bundle/vim-plug/plug.vim $HOME/.vim/autoload/plug.vim
    augroup FirstPlugInstall
      autocmd! VimEnter * PlugInstall --sync | source $MYVIMRC
    augroup END
  endif
""" }}}

""" Plugins to disable
""" https://github.com/timss/vimconf/issues/13
" Create empty list with names of disabled plugins if not defined
let g:plugs_disabled = get(g:, 'plug_disabled', [])

" Trim and extract repo name
" Same substitute/fnamemodify args as vim-plug itself
" https://github.com/junegunn/vim-plug/issues/469#issuecomment-226965736
function! s:plugs_disable(repo)
  let l:repo = substitute(a:repo, '[\/]\+$', '', '')
  let l:name = fnamemodify(l:repo, ':t:s?\.git$??')
  call add(g:plugs_disabled, l:name)
endfunction

" Append to list of repo names to be disabled just like they're added
" UnPlug 'junegunn/vim-plug'
command! -nargs=1 -bar UnPlug call s:plugs_disable(<args>)

" Default to same plugin directory as vundle etc
call plug#begin('~/.vim/bundle')
  " <Tab> everything!
  Plug 'ervandew/supertab'

  " Fuzzy finder (files, mru, etc)
  Plug 'ctrlpvim/ctrlp.vim'

  " A pretty statusline, bufferline integration
  Plug 'itchyny/lightline.vim'
  Plug 'bling/vim-bufferline'

  " Undo history visualizer
  Plug 'mbbill/undotree'

  " Nord
  Plug 'arcticicestudio/nord-vim'

  " Universal commenting with toggle, motions, embedded syntax and more
  Plug 'tomtom/tcomment_vim'

  " Autoclose (, " etc
  Plug 'somini/vim-autoclose'

  " Handle surround chars like ''
  Plug 'tpope/vim-surround'

  " Align your = etc.
  Plug 'junegunn/vim-easy-align'

  " A fancy start screen, shows MRU etc.
  Plug 'mhinz/vim-startify'

  " Vim signs (:h signs) for modified lines based off VCS (e.g. Git)
  Plug 'mhinz/vim-signify'

  " Awesome syntax checker.
  " REQUIREMENTS: See :h syntastic-intro
  Plug 'vim-syntastic/syntastic'

  " Local plugins
  if filereadable($HOME.'/.vimrc.plugins')
    source $HOME/.vimrc.plugins
  endif

  " Remove disabled plugins from installation/initialization
  " https://vi.stackexchange.com/q/13471/5070
  call filter(g:plugs, 'index(g:plugs_disabled, v:key) == -1')

" Initalize plugin system
call plug#end()

""" Local leading config, only for prerequisites and will be overwritten
if filereadable($HOME.'/.vimrc.first')
  source $HOME/.vimrc.first
endif

source $HOME/git/confs/dots/vim/user-interface
source $HOME/git/confs/dots/vim/general-settings

""" Files {{{
  set autoread                                    " refresh if changed
  set confirm                                     " confirm changed files
  set noautowrite                                 " never autowrite
  set nobackup                                    " disable backups
  """ Swap files, unless vim is invoked using sudo {{{
  """ https://github.com/tejr/dotfiles/blob/master/vim/vimrc
    if !strlen($SUDO_USER)
      set directory^=$HOME/.vim/swap//        " default cwd, // full path
      set swapfile                            " enable swap files
      set updatecount=50                      " update swp after 50chars
      """ Don't swap tmp, mount or network dirs {{{
        augroup SwapIgnore
          autocmd! BufNewFile,BufReadPre /tmp/*,/mnt/*,/media/*
            \ setlocal noswapfile
        augroup END
      """ }}}
    else
      set noswapfile                          " dont swap sudo'ed files
    endif
  """ }}}
""" }}}

""" Text formatting {{{
    set autoindent                                  " preserve indentation
    set backspace=indent,eol,start                  " smart backspace
    set cinkeys-=0#                                 " don't force # indentation
    set expandtab                                   " indents <Tab> as spaces
    set ignorecase                                  " by default ignore case
    set nrformats+=alpha                            " incr/decr letters C-a/-x
    set shiftround                                  " be clever with tabs
    set shiftwidth=2                                " default 8
    set smartcase                                   " sensitive with uppercase
    set smarttab                                    " tab to 0,4,8 etc.
    set softtabstop=2                               " "tab" feels like <tab>
    set tabstop=2                                   " replace <TAB> w/2 spaces
    """ Only auto-comment newline for block comments {{{
      augroup AutoBlockComment
        autocmd! FileType c,cpp setlocal comments -=:// comments +=f://
      augroup END
    """ }}}
    """ Take comment leaders into account when joining lines, :h fo-table {{{
    """ http://ftp.vim.org/pub/vim/patches/7.3/7.3.541
      if has('patch-7.3.541')
        set formatoptions+=j
      endif
    """ }}}
""" }}}

""" Keybindings {{{
    """ General {{{

        """ Workspaces {{{
          nnoremap <C-a> <C-w>
          nmap <C-a>\| <C-w>v
          nmap <C-a>- <C-w>s

          nmap <Esc>[1;3A <C-a>k
          nmap <Esc>[1;3B <C-a>j
          nmap <Esc>[1;3D <C-a>h
          nmap <Esc>[1;3C <C-a>l
        """ }}}

        " Remap <Leader>
        let g:mapleader=','


        """v<CR>
        """nnoremap <C-a>- <C-w>s<CR>

        " Quickly edit/source .vimrc
        noremap <Leader>ve :edit $HOME/.vimrc<CR>
        noremap <Leader>vs :source $HOME/.vimrc<CR>

        " Yank(copy) to system clipboard
        noremap <Leader>y "+y

        " Toggle pastemode, doesn't indent
        set pastetoggle=<F3>

        " Toggle folding
        " http://vim.wikia.com/wiki/Folding#Mappings_to_toggle_folds
        nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>

        " Toggle relativenumber
        nnoremap <silent> <Leader>r :set relativenumber!<CR>

        " Treat wrapped lines as normal lines
        nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
        nnoremap <expr> j v:count == 0 ? 'gj' : 'j'

        " Quickly switch buffers
        nnoremap <Leader>d :bdelete<CR>
        nnoremap <Leader>n :bnext<CR>
        nnoremap <Leader>p :bprevious<CR>
        nnoremap <Leader>f :b#<CR>

        " Highlight last inserted text
        nnoremap gV '[V']
    """ }}}
    """ Functions and/or fancy keybinds {{{
        """ Highlight characters past 79, toggle with <Leader>h {{{
        """ You might want to override this function and its variables with
        """ your own in .vimrc.last which might set for example colorcolumn or
        """ even the textwidth.
            let g:overlength_enabled = 0
            highlight OverLength ctermbg=238 guibg=#444444

            function! ToggleOverLength()
                if g:overlength_enabled == 0
                    match OverLength /\%79v.*/
                    let g:overlength_enabled = 1
                    echo 'OverLength highlighting turned on'
                else
                    match
                    let g:overlength_enabled = 0
                    echo 'OverLength highlighting turned off'
                endif
            endfunction

            nnoremap <Leader>h :call ToggleOverLength()<CR>
        """ }}}
        """ Toggle text wrapping, wrap on whole words {{{
        """ For more info see: http://stackoverflow.com/a/2470885/1076493
            function! WrapToggle()
                if &wrap
                    set list
                    set nowrap
                else
                    set nolist
                    set wrap
                endif
            endfunction

            nnoremap <Leader>w :call WrapToggle()<CR>
        """ }}}
        """ Remove multiple empty lines {{{
            function! DeleteMultipleEmptyLines()
                g/^\_$\n\_^$/d
            endfunction

            nnoremap <Leader>ld :call DeleteMultipleEmptyLines()<CR>
        """ }}}
        """ Split to relative header/source {{{
            function! SplitRelSrc()
                let l:fname = expand('%:t:r')

                if expand('%:e') ==? 'h'
                    set nosplitright
                    exe 'vsplit' fnameescape(l:fname . '.cpp')
                    set splitright
                elseif expand('%:e') ==? 'cpp'
                    exe 'vsplit' fnameescape(l:fname . '.h')
                endif
            endfunction

            nnoremap <Leader>le :call SplitRelSrc()<CR>
        """ }}}
        """ Strip trailing whitespace, return to cursor at save {{{
            function! StripTrailingWhitespace()
                let l:save = winsaveview()
                %s/\s\+$//e
                call winrestview(l:save)
            endfunction

            augroup StripTrailingWhitespace
                autocmd!
                autocmd FileType c,cpp,cfg,conf,css,html,perl,python,sh,tex,yaml
                    \ autocmd BufWritePre <buffer> :call
                    \ StripTrailingWhitespace()
            augroup END
        """ }}}
    """ }}}
    """ Plugins {{{
        " Toggle undo history tree
        nnoremap <F5> :UndotreeToggle<CR>

        " Syntastic - toggle error list. Probably should be toggleable.
        noremap <silent><Leader>lo :Errors<CR>
        noremap <silent><Leader>lc :lclose<CR>

        " EasyAlign - interactive mode (e.g. vipga/gaip)
        xmap ga <Plug>(EasyAlign)
        nmap ga <Plug>(EasyAlign)
    """ }}}

source $HOME/git/confs/dots/vim/plugin-settings

""" Local ending config, will overwrite anything above. Generally use this. {{{
  if filereadable($HOME.'/.vimrc.last')
    source $HOME/.vimrc.last
  endif
""" }}}
