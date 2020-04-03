if ! empty($NEOVIM_PYTHON_PATH)
    let g:python3_host_prog = $NEOVIM_PYTHON3_PATH
    let g:python_host_prog = $NEOVIM_PYTHON_PATH
end
let g:loaded_ruby_provider = 0
" let g:loaded_node_provider = 1

call plug#begin()
"" Neovim configuration
function! DoRemote(arg)
	UpdateRemotePlugins
endfunction
"" Vim Utils
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
" Plug 'tpope/vim-sleuth'  " autodetect indent
Plug 'tpope/vim-eunuch'  " Helpers for Move, Delete etc operations
Plug 'tpope/vim-dadbod', {'for': 'sql'}
" Plug 'junegunn/fzf'
Plug 'junegunn/vim-peekaboo'
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary!' }
Plug 'junegunn/vim-easy-align'
Plug 'majutsushi/tagbar'   " deps: universal-ctags
Plug 'kshenoy/vim-signature'  " show marks in gutter
Plug 'mbbill/undotree'  " menu with undo
Plug 'itchyny/lightline.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'Yggdroot/indentLine'  " add markers for indent
Plug 'chriskempson/base16-vim'
Plug 'drmikehenry/vim-extline'  " CTRL-L to underline and overline lines
Plug 'neovimhaskell/haskell-vim'
" Code utils
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'jalvesaq/vimcmdline', {'for': ['python', 'julia', 'sql', 'sh']}
Plug 'ludovicchabant/vim-gutentags'

Plug 'Vimjas/vim-python-pep8-indent', {'for' : 'python'}
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'ekalinin/Dockerfile.vim'
Plug 'lifepillar/pgsql.vim'
Plug 'keith/swift.vim'

Plug 'kamykn/spelunker.vim'

if $NEOVIM_JS == '1'
    Plug 'othree/yajs.vim', {'for': 'javascript'}
    Plug 'HerringtonDarkholme/yats.vim', {'for': 'typescript'}
    Plug 'MaxMEllon/vim-jsx-pretty', {'for': ['javascript', 'typescript']}
    Plug 'Quramy/vim-js-pretty-template', {'for': ['javascript', 'typescript']}
    Plug 'mhartington/nvim-typescript', {'do': './install.sh', 'for': 'typescript'}
    Plug 'iloginow/vim-stylus'
    Plug 'Valloric/MatchTagAlways', {'for' : 'html'}
endif
if $NEOVIM_GO == '1'
    Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries', 'for': 'go'}
endif
if $NEOVIM_SCI == '1'
    Plug 'lervag/vimtex', {'for': 'tex'}
    Plug 'jalvesaq/Nvim-R', {'for' : 'r'}
    Plug 'JuliaEditorSupport/julia-vim'
endif
call plug#end()

"" Basic Settings
syntax on
set noshowcmd noruler  " improve scrolling
let mapleader = ";"
set autoindent
" smart tabs configuration - use tabs for indent and spaces for align
set noexpandtab copyindent preserveindent softtabstop=0 shiftwidth=4 tabstop=4
set number  " always show linenumbers
set ignorecase smartcase  " search options
set mouse=a
set wrap linebreak formatoptions-=t breakindent  " setup wordwrap
set vb t_vb=  " no beeping
set splitbelow splitright  " split settings
set textwidth=80  " set textwidth to 80 chars
let &colorcolumn="80,".join(range(120,999),",")  " color background past 80 chars
au TermOpen * setlocal nonu  " disable linenumbers in terminal

"" Theme Settings
if $TERM=~'linux'
	set guicursor=
else
    " set colorscheme for 256-color supported terminals
    set termguicolors
    colorscheme base16-tomorrow-night
    set background=dark
end

"" Plugin Configuration
let g:coc_global_extensions = [
	    \ 'coc-python',
	    \ 'coc-tsserver', 'coc-html', 'coc-css',
	    \ 'coc-vimlsp', 'coc-vimtex',
	    \ 'coc-go',
	    \ 'coc-texlab',
	    \ 'coc-r-lsp',
	    \ 'coc-docker', 'coc-sh',
	    \ 'coc-ultisnips',
	    \]
let g:undotree_WindowLayout = 3

let g:haskell_indent_disable = 0

function WordCount()
  let cur_mode = mode()
  if cur_mode ==? "v"
     return wordcount().visual_words
   elseif cur_mode ==? "i"
    return b:cur_wordcount
  endif
  let b:cur_wordcount = wordcount().words
  return b:cur_wordcount
endfunction

function WordCountStatus()
  if get(b:, "wordcount_enabled", 0) == 1
    return WordCount() . " words"
  else
    return ""
  endif
endfunction

autocmd FileType text,markdown let b:wordcount_enabled = 1

" Lightline
let g:lightline = {
			\  'colorscheme': 'Tomorrow_Night',
			\  'component': {
			\    'charvaluehex': '0x%B',
			\  },
			\ 'component_function': {
			\    'cocstatus': 'coc#status',
			\    'wordcountfun': 'WordCountStatus',
			\  },
			\  'active': {
			\     'right': [
			\        [ 'lineinfo' ],
			\        [ 'percent'  ],
			\        [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex'],
			\        [ 'cocstatus', 'wordcountfun' ],
			\     ]
			\  },
			\}
" do not show the insert status, since we have lightline
set noshowmode
" Whitespace - Tabs line Spaces dotted
let g:indentLine_char = '┆'
let g:indentLine_setConceal = 0
set list lcs=tab:\│\ ,nbsp:␣,extends:⟩,precedes:⟨,
hi Whitespace ctermfg=19
" Nvim-R disable assign operator keybinding
let R_assign = 0
let R_app = "radian"
let R_cmd = "R"
let R_hl_term = 0
" let R_args = []  " if you had set any
let R_bracketed_paste = 1
" Tagbar settings
let g:tagbar_left = 0
let g:tagbar_sort = 0

" gutentags config
let g:gutentags_exclude_filetypes = ['.txt', '.md', '.rst', '.json', '.xml', '.sh', '.bash']
let g:gutentags_cache_dir = '~/.cache/tags'
let g:gutentags_file_list_command = {
			\ 'markers': {
			\ '.git': 'git ls-files',
			\ '.hg': 'hg files',
			\ },
			\ }

" vimcmdline settings
let cmdline_app                = {'python': 'ipython3', 'julia': 'julia', 'sh': 'bash'}
let cmdline_map_start          = '<LocalLeader>rf'
let cmdline_map_send           = '<LocalLeader>l'
let cmdline_map_source_fun     = '<LocalLeader>f'
let cmdline_map_send_paragraph = '<LocalLeader>p'
let cmdline_map_send_block     = '<LocalLeader>b'
let cmdline_map_quit           = '<LocalLeader>rq'
let cmdline_vsplit             = 1
let cmdline_term_width         = 80

"" Snippet configuration
" c-j c-k for moving in snippet
let g:UltiSnipsExpandTrigger            = '<Nop>'
let g:UltiSnipsJumpForwardTrigger = '<TAB>'
let g:UltiSnipsJumpBackwardTrigger = '<S-TAB>'
let g:UltiSnipsRemoveSelectModeMappings = 0
let g:UltiSnipsEditSplit                = "vertical"
let g:coc_snippet_next                  = '<Tab>'
let g:coc_snippet_prev                  = '<S-Tab>'

" latex settings
let g:vimtex_view_method       = "skim"
let g:tex_flavor               = "latex"
let g:vimtex_compiler_progname = "nvr"
let g:tex_conceal              = ""

" spelunker settings
set spelllang=en_us,de_de
set nospell  " since we already have spelunker

let g:spelunker_disable_auto_group = 1
augroup spelunker
  autocmd!
  " Setting for g:spelunker_check_type = 1:
  autocmd BufWinEnter,BufWritePost *.md,*.tex,*.latex,*.txt call spelunker#check()

  " Setting for g:spelunker_check_type = 2:
  autocmd CursorHold *.md,*.tex,*.latex,*.txt call spelunker#check_displayed_words()
augroup END

" Clipboard settings
set clipboard=unnamedplus

" keybindings for window switching
tnoremap <Esc> <C-\><C-n>
inoremap <c-c> <ESC>

" Start interactive EasyAlign in visual mode or motion/text object (e.g. vipga)
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

nnoremap <leader><C-r> :UndotreeToggle<CR>
nnoremap <leader><C-w> :ToggleWhitespace<CR>
nnoremap <leader><C-t> :TagbarToggle<CR>

"" COC settings
set nobackup nowritebackup hidden
set cmdheight=1
set updatetime=300 shortmess+=c signcolumn=yes
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')
nmap <leader>rn <Plug>(coc-rename)
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" nmap <silent> <C-d> <Plug>(coc-range-select)
" xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

"" Custom keybindings
" setup arrowkeys for visual scroll
noremap  <buffer> <silent> <Up>   gk
noremap  <buffer> <silent> <Down> gj
noremap  <buffer> <silent> <Home> g<Home>
noremap  <buffer> <silent> <End>  g<End>
inoremap <buffer> <silent> <Up>   <C-o>gk
inoremap <buffer> <silent> <Down> <C-o>gj
inoremap <buffer> <silent> <Home> <C-o>g<Home>
inoremap <buffer> <silent> <End>  <C-o>g<End>
" remove highlight with escape in normal mode
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[

nnoremap <Leader>i  mzgg=G`z :retab<CR>
nnoremap <leader>b :Clap buffers<CR>
nnoremap <leader><space> :Clap files<CR>
nnoremap <leader>g :Clap grep<CR>
nnoremap <leader><c-p> :CocCommand python.setInterpreter<CR>
