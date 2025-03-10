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

" Added plugins for markdown link completion and backlinking
Plug 'hrsh7th/nvim-cmp'            " Autocompletion framework
Plug 'hrsh7th/cmp-buffer'          " Buffer source for nvim-cmp
Plug 'hrsh7th/cmp-path'            " Path source for nvim-cmp
Plug 'saadparwaiz1/cmp_luasnip'    " Snippet source for nvim-cmp
Plug 'L3MON4D3/LuaSnip'            " Snippet engine

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
set completeopt=menuone,noinsert,noselect  " Better completion
set conceallevel=2         " Enable concealing for markdown

" Performance optimizations
set maxmempattern=2000     " Limit memory usage for pattern matching
set lazyredraw             " Don't redraw screen during macros
set shm+=I                 " Disable intro message
set synmaxcol=200          " Only highlight 200 columns for syntax

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
        transform_implicit = function(text)
            -- Convert spaces to dashes and lowercase for filenames
            return text:gsub(' ', '-'):lower()
        end,
        context_aware_execution = true,
        -- Recognize more link types
        recognize = {
            file = true,
            url = true,
            wiki = true,   -- [[WikiLinks]]
            md = true      -- [Text](link.md)
        }
    },
    lists = {
        indent_with_bullets = true
    },
    mappings = {
        MkdnEnter = {{'n', 'v'}, '<CR>'},
        MkdnNextLink = {'n', '<Tab>'},
        MkdnPrevLink = {'n', '<S-Tab>'},
        MkdnNextHeading = {'n', ']]'},
        MkdnPrevHeading = {'n', '[['},
        MkdnGoBack = {'n', '<BS>'},
        MkdnGoForward = {'n', '<Del>'},
        MkdnCreateLink = {'n', '<leader>cl'},       -- Create link
        MkdnFollowLink = {'n', '<leader>fl'},       -- Follow link
        MkdnCreateNewFile = {'n', '<leader>nf'},
        MkdnDestroyLink = {'n', '<leader>dl'},      -- Remove link but keep text
        MkdnTagSpan = {'v', '<leader>mt'},          -- Mark selected text as a span
        MkdnToggleToDo = {'n', '<leader>tt'},       -- Toggle to-do item
    },
    -- Enhanced Markdown link detection
    links_find_in_range = 80,         -- Link search range (performance optimization)
    use_mappings_table = true,
    perspective = {
        priority = 'current',
        fallback = 'first',
        root_tell = 'index.md',
        nvim_wd_heel = true
    },
    silent = true,
    modules = {
        folds = true,
        tables = true,
        lists = true,
        diary = true
    },
    cursor_behavior = {
        preserve_col = true           -- Preserve cursor column when navigating
    }
})

-- Telescope configuration with backlink support
require('telescope').setup {
  defaults = {
    prompt_prefix = "❯ ",
    selection_caret = "❯ ",
    path_display = { "truncate" },
    file_ignore_patterns = { ".git/", "node_modules/", "target/", "docs/", ".settings/" },
    vimgrep_arguments = {
        'rg', '--color=never', '--no-heading',
        '--with-filename', '--line-number',
        '--smart-case', '-L', '--trim'
    },
    cache_picker = {
        num_processes = 1         -- Optimize for lower-end hardware
    },
    preview = {
        timeout = 200,            -- Lower timeout for better performance
        treesitter = false        -- Disable treesitter for preview (performance)
    }
  },
  pickers = {
    find_files = { theme = "dropdown" },
    live_grep = {
      additional_args = function() return { "--hidden" } end,
      theme = "dropdown",
    },
    backlinks = {
        theme = "dropdown",
        layout_config = {
            width = 0.6,
            height = 0.6,
        }
    }
  },
}

-- Setup nvim-cmp with special handling for markdown links
local cmp = require('cmp')
local luasnip = require('luasnip')

-- Add markdown link snippets
luasnip.add_snippets("markdown", {
    luasnip.snippet("link", {
        luasnip.text_node("["),
        luasnip.insert_node(1, "Link text"),
        luasnip.text_node("]("),
        luasnip.insert_node(2, "url"),
        luasnip.text_node(")"),
    }),
    luasnip.snippet("wlink", {
        luasnip.text_node("[["),
        luasnip.insert_node(1, "Wiki Link"),
        luasnip.text_node("]]"),
    }),
})

-- Custom source for markdown files and wiki links
local markdown_source = {}
markdown_source.new = function()
    return setmetatable({}, { __index = markdown_source })
end

markdown_source.get_trigger_characters = function()
    return { '[' }
end

markdown_source.complete = function(self, params, callback)
    local line = params.context.cursor_line:sub(1, params.context.cursor.col - 1)
    
    -- Only trigger for markdown files and when inside a potential link
    if vim.bo.filetype ~= 'markdown' or not (line:match('%[%[$') or line:match('%[.*%]%(')) then
        callback({ items = {}, isIncomplete = false })
        return
    end
    
    local is_wiki_link = line:match('%[%[$')
    local items = {}
    
    -- Get all markdown files from the working directory
    local md_files = vim.fn.glob(vim.fn.getcwd() .. '/**/*.md', false, true)
    for _, file in ipairs(md_files) do
        local filename = vim.fn.fnamemodify(file, ':t:r')
        local rel_path = vim.fn.fnamemodify(file, ':~:.')
        
        table.insert(items, {
            label = filename,
            detail = rel_path,
            insertText = is_wiki_link and filename or rel_path,
            documentation = "Link to " .. rel_path,
            kind = cmp.lsp.CompletionItemKind.File
        })
    end
    
    callback({ items = items, isIncomplete = false })
end

-- Register our custom source
cmp.register_source('markdown_links', markdown_source.new())

-- Setup completion
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        },
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end,
    },
    sources = {
        { name = 'luasnip' },
        { name = 'markdown_links', priority = 10, group_index = 1 },
        { name = 'buffer', keyword_length = 3 },
        { name = 'path' },
    },
    enabled = function()
        -- Only enable in markdown files
        return vim.bo.filetype == 'markdown' or
               vim.api.nvim_buf_get_name(0):match('%.md$')
    end,
    window = {
        documentation = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            max_height = 15,
            max_width = 60,
        },
    },
    experimental = {
        ghost_text = false, -- Disable for performance
    }
})

-- Function to find backlinks to the current file
function find_backlinks()
    local current_file = vim.fn.expand('%:t')
    if current_file == '' then
        vim.notify("No file open", vim.log.levels.WARN)
        return
    end
    
    -- Build search pattern to find links to this file
    local pattern = '%[.-%]%(' .. current_file .. '%)'
    
    -- Use telescope live_grep with our pattern
    require('telescope.builtin').live_grep({
        default_text = pattern,
        prompt_title = "Backlinks to " .. current_file,
    })
end

-- Define a global function to be used in keymaps
_G.find_backlinks = find_backlinks
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

" Backlink finding
nnoremap <leader>bl <cmd>lua find_backlinks()<cr>

" Markdown-specific mappings
autocmd FileType markdown inoremap ;l []()<Left><Left><Left>
autocmd FileType markdown inoremap ;w [[]]<Left><Left>
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
        
        " Add a backlinks section at the end of the file
        call append(line('$'), ['', '## Backlinks', ''])
        
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
    autocmd FileType markdown setlocal conceallevel=2
augroup END
" Only apply template for new markdown files when NOT created through NewMarkdownFile
augroup markdown_templates
    autocmd!
    " Only apply template if not already handled by NewMarkdownFile
    autocmd BufNewFile *.md if g:markdown_template_applied == 0 | call ApplyTemplate('skeleton.md') | endif
augroup END

" Autocommands for backlinks
augroup backlinks
    autocmd!
    " Update backlinks section on save
    autocmd BufWritePre *.md lua require('mkdnflow').update_links()
    
    " Check for broken links when opening markdown files
    autocmd BufReadPost *.md lua vim.defer_fn(function() require('mkdnflow').update_links() end, 500)
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

" Update backlinks section in current file
function! UpdateBacklinksSection()
    " Save current position
    let save_pos = getpos(".")
    
    " Find or create the backlinks section
    if search('^## Backlinks', 'w') == 0
        " If not found, add it at the end
        call append(line('$'), ['', '## Backlinks', ''])
        call cursor(line('$'), 1)
    else
        " If found, clear existing content
        let start_line = line('.')
        let end_line = search('^##', 'n') - 1
        if end_line <= start_line
            let end_line = line('$')
        endif
        
        " Delete everything between the backlinks heading and the next heading
        if end_line > start_line
            execute (start_line + 1) . ',' . end_line . 'delete'
        endif
        
        " Add an empty line after the heading
        call append(start_line, '')
    endif
    
    " Restore cursor position
    call setpos('.', save_pos)
endfunction
command! UpdateBacklinks call UpdateBacklinksSection()

" Add a command to manually update all links in the current file
command! UpdateLinks lua require('mkdnflow').update_links()