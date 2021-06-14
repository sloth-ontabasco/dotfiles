colorscheme onedark
let g:neovide_transparency=0.95
let g:neovide_cursor_vfx_mode = "torpedo"
set relativenumber
set guifont=FiraMono\ Nerd\ Font,Noto\ Color\ Emoji:h18
let mapleader=" "
nnoremap <C-n> :NERDTree<CR>
noremap  <silent> j gj
noremap  <silent> k gk
set clipboard=unnamedplus
if &compatible
  set nocompatible
endif

function! s:packager_init(packager) abort
  call a:packager.add('kristijanhusak/vim-packager', { 'type': 'opt' })
  call a:packager.add('Yggdroot/indentLine')
  call a:packager.add('dense-analysis/ale')
  call a:packager.add('neoclide/coc.nvim')
  call a:packager.add('ryanoasis/vim-devicons')
  call a:packager.add('Shougo/defx.nvim')
  call a:packager.add('lukas-reineke/indent-blankline.nvim')
  call a:packager.add('preservim/nerdtree')
  call a:packager.add('sheerun/vim-polyglot')
  call a:packager.add('andymass/vim-matchup')
  call a:packager.add('haya14busa/vim-asterisk')
  call a:packager.add('tpope/vim-sleuth')
  call a:packager.add('tpope/vim-fugitive')
  call a:packager.add('tpope/vim-surround')
  call a:packager.add('preservim/nerdcommenter')
  call a:packager.add('roxma/nvim-yarp')
  call a:packager.add('roxma/vim-hug-neovim-rpc')
  call a:packager.add('kristijanhusak/defx-git')
endfunction
filetype plugin on
packadd vim-packager
call packager#setup(function('s:packager_init'))
