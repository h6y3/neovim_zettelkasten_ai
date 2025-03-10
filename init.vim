" ========================================================================
" Neovim Configuration
" ========================================================================

" Vim-plug setup
" Automatically install vim-plug if not installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin(data_dir . '/plugged')

" Core plugins based on requirements
Plug 'junegunn/seoul256.vim'       " Color scheme
Plug 'jakewvincent/mkdnflow.nvim', { 'branch': 'dev' }  " Markdown workflow

" Essential utilities
Plug 'preservim/nerdtree'          " File explorer
Plug 'tpope/vim-commentary'        " Commenting support
Plug 'tpope/vim-surround'          " Surroundings manipulation
Plug 'jiangmiao/auto-pairs'        " Auto-close pairs

" Telescope for file finding
Plug 'nvim-lua/plenary.nvim'       " Required by telescope
Plug 'nvim-telescope/telescope.nvim'  " Fuzzy finder

call plug#end()

" ========================================================================
" Basic Settings
" ========================================================================

" Color scheme
set background=dark
silent! colorscheme seoul256

" General settings
syntax enable              " Enable syntax highlighting
set number relativenumber  " Show line numbers (both absolute and relative)
set mouse=a                " Enable mouse support
set clipboard+=unnamedplus " Use system clipboard
set expandtab              " Use spaces instead of tabs
set tabstop=4 shiftwidth=4 softtabstop=4  " Tab settings
set smartindent            " Smart indentation
set wrap linebreak         " Smart line wrapping
set ignorecase smartcase   " Smart case sensitivity for search
set incsearch hlsearch     " Search settings
set splitbelow splitright  " Split window behavior
set hidden                 " Allow switching buffers without saving
set termguicolors          " True color support
set scrolloff=8            " Keep lines visible when scrolling
set signcolumn=yes         " Always show sign column
set updatetime=300         " Faster update time
set timeoutlen=500         " Faster key sequence completion
set completeopt=menuone,noselect  " Better completion

" Global variables
let g:markdown_template_applied = 0  " Flag to prevent double template application

" ========================================================================
" Plugin Configurations
" ========================================================================

" Template directory configuration
let g:template_dir = expand('~/.config/nvim/templates')

" mkdnflow configuration
lua << EOF
require('mkdnflow').setup({
    links = {
        conceal = true,
        transform_explicit = false,
    },
    mappings = {
        MkdnEnter = {{'n', 'v'}, '<CR>'},
        MkdnNextLink = {'n', '<Tab>'},
        MkdnPrevLink = {'n', '<S-Tab>'},
        MkdnNextHeading = {'n', ']]'},
        MkdnPrevHeading = {'n', '[['},
        MkdnGoBack = {'n', '<BS>'},
        MkdnGoForward = {'n', '<Del>'},
        MkdnCreateNewFile = {'n', '<leader>nf'},
    }
})

-- Telescope configuration
require('telescope').setup {
  defaults = {
    prompt_prefix = "❯ ",
    selection_caret = "❯ ",
    path_display = { "truncate" },
    file_ignore_patterns = { ".git/", "node_modules/", "target/", "docs/", ".settings/" },
  },
  pickers = {
    find_files = { theme = "dropdown" },
    live_grep = {
      additional_args = function() return { "--hidden" } end
    },
  },
}
EOF

" ========================================================================
" Key mappings
" ========================================================================

let mapleader = " "  " Set leader key to space

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" NERDTree
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fd <cmd>DocFiles<cr>
nnoremap <leader>fD <cmd>DocGrep<cr>

" Quick commands
nnoremap <leader>h :nohlsearch<CR>        " Clear search highlighting
nnoremap <leader>w :w<CR>                 " Quick save
nnoremap <leader>q :q<CR>                 " Quick quit
nnoremap <leader>sv :source $MYVIMRC<CR>  " Source init.vim

" Template application
nnoremap <leader>t :Template skeleton.md<CR>

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" ========================================================================
" Tag Processing Functions
" ========================================================================

" Function to format tags with double brackets
function! FormatTags(tags_string)
    " Trim the input string
    let trimmed = trim(a:tags_string)
    if empty(trimmed)
        return '[[]]'
    endif
    
    " Split by comma and trim each tag
    let tags = split(trimmed, ',')
    let formatted_tags = []
    
    " Format each tag with double brackets
    for tag in tags
        let trimmed_tag = trim(tag)
        if !empty(trimmed_tag)
            call add(formatted_tags, '[[' . trimmed_tag . ']]')
        endif
    endfor
    
    " Join with commas
    return join(formatted_tags, ', ')
endfunction

" Function to prompt for tags
function! PromptForTags()
    let tags_input = input('Tags (separated by comma): ')
    return FormatTags(tags_input)
endfunction

" ========================================================================
" Template System
" ========================================================================

" Universal template function
function! ApplyTemplate(template, ...)
    let template_path = g:template_dir . '/' . a:template
    if filereadable(template_path)
        " Make sure we're at the start of the file
        normal! gg
        
        " Read template file at the top of the buffer
        execute '0read ' . template_path
        
        " Get the title - either from the argument or the filename
        let title = a:0 > 0 ? a:1 : expand('%:t:r')
        
        " Prompt for tags
        let formatted_tags = PromptForTags()
        
        " Expand common variables
        silent! %s/{{date}}/\=strftime('%Y-%m-%d')/ge
        silent! %s/{{title}}/\=title/ge
        silent! %s/{{tags}}/\=formatted_tags/ge
        
        " Position cursor at the end of the file and enter insert mode
        normal! G
        startinsert
        
        " Mark as modified to ensure save works properly
        set modified
    else
        echo "Template not found: " . template_path
    endif
endfunction

" Commands for templates
command! -nargs=1 -complete=file Template call ApplyTemplate(<f-args>)
command! MDTemplate call ApplyTemplate('skeleton.md')

" ========================================================================
" Auto commands
" ========================================================================

" Remember last cursor position
augroup remember_position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

" Markdown-specific settings
augroup markdown
    autocmd!
    autocmd FileType markdown setlocal spell textwidth=80
augroup END

" Only apply template for new markdown files when NOT created through NewMarkdownFile
augroup markdown_templates
    autocmd!
    " Only apply template if not already handled by NewMarkdownFile
    autocmd BufNewFile *.md if g:markdown_template_applied == 0 | call ApplyTemplate('skeleton.md') | endif
augroup END

" ========================================================================
" Custom Functions
" ========================================================================

" Create directory if it doesn't exist and edit the file
function! CreateAndEdit(file)
    let l:dir = fnamemodify(a:file, ':h')
    if !isdirectory(l:dir)
        call mkdir(l:dir, 'p')
    endif
    execute 'edit ' . a:file
endfunction

command! -nargs=1 -complete=file CE call CreateAndEdit(<f-args>)

" Sanitize title to create a suitable filename
function! SanitizeFilename(title)
    let sanitized = substitute(a:title, '[^a-zA-Z0-9]', '_', 'g')  " Replace non-alphanumeric characters with underscores
    return tolower(sanitized)  " Convert to lowercase
endfunction

" Create new Markdown file with template
function! NewMarkdownFile()
    let original_title = input('New Markdown file title: ')  " Prompt for title
    if empty(original_title)
        echo "Cancelled"
        return
    endif
    
    " Create sanitized filename
    let filename = SanitizeFilename(original_title) . '.md'
    
    " Set the global flag to prevent autocommand from applying template
    let g:markdown_template_applied = 1
    
    " Create and edit the file
    call CreateAndEdit(filename)
    
    " Apply template with original title, not the filename
    call ApplyTemplate('skeleton.md', original_title)
    
    " Reset the flag for future file creations
    " We use timer_start to ensure this happens after all autocommands complete
    call timer_start(100, {-> execute('let g:markdown_template_applied = 0', '')})
endfunction

command! NewMarkdown call NewMarkdownFile()
nnoremap <leader>n :NewMarkdown<CR>

" Search in Documents with Telescope
function! SearchInDocuments()
    lua require('telescope.builtin').find_files({cwd = vim.fn.expand('~/Documents')})
endfunction

function! GrepInDocuments()
    lua require('telescope.builtin').live_grep({cwd = vim.fn.expand('~/Documents')})
endfunction

command! DocFiles call SearchInDocuments()
command! DocGrep call GrepInDocuments()