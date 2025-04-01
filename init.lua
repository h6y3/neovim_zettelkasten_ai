-- init.lua for Neovim with lazy.nvim

-- Set leader key BEFORE loading plugins (critical!)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic options (moved from init.vim)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.hidden = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.conceallevel = 2
vim.opt.background = "dark"

-- Performance optimizations
vim.opt.maxmempattern = 2000
vim.opt.lazyredraw = true
vim.opt.shortmess:append("I")
vim.opt.synmaxcol = 200

-- Global variables
vim.g.markdown_template_applied = 0
vim.g.template_dir = vim.fn.expand('~/.config/nvim/templates')

-- Define custom telescope utils in global scope so they're available before the plugin loads
-- FIXED: Create utility functions that will be attached to telescope when loaded
_G.telescope_custom_utils = {
  -- Throttled live grep function for better performance
  throttle_live_grep = function()
    -- Get current visual selection for prefiltering
    local visual_selection = ""
    if vim.fn.mode() == 'v' or vim.fn.mode() == 'V' then
      local saved_reg = vim.fn.getreg('"')
      vim.cmd('noau normal! "vy"')
      visual_selection = vim.fn.getreg('"')
      vim.fn.setreg('"', saved_reg)
    end
    
    require('telescope.builtin').live_grep({
      default_text = visual_selection,
      prompt_title = "Live Grep (Optimized)",
    })
  end,
  
  -- Function to find backlinks
  find_backlinks = function()
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
}

-- Define the plugins
require("lazy").setup({
  -- Color scheme
  {
    "junegunn/seoul256.vim",
    priority = 1000, -- Load first
    config = function()
      vim.cmd([[colorscheme seoul256]])
    end,
  },
  
  -- Markdown workflow (using dev branch)
  {
    "jakewvincent/mkdnflow.nvim",
    branch = "dev",
    ft = "markdown", -- Load only for markdown files
    opts = {
      links = {
        conceal = true,
        transform_explicit = false,
        transform_implicit = function(text)
          -- Convert spaces to dashes and lowercase for filenames
          return text:gsub(' ', '-'):lower()
        end,
        context = 2, -- Handle multi-line links
        recognize = {
          file = true,
          url = true,
          wiki = true, -- [[WikiLinks]]
          md = true    -- [Text](link.md)
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
        MkdnCreateLink = {'n', '<leader>cl'}, -- Create link
        MkdnFollowLink = {'n', '<leader>fl'}, -- Follow link
        MkdnCreateNewFile = {'n', '<leader>nf'},
        MkdnDestroyLink = {'n', '<leader>dl'}, -- Remove link but keep text
        MkdnTagSpan = {'v', '<leader>mt'},    -- Mark selected text as a span
        MkdnToggleToDo = {'n', '<leader>tt'}, -- Toggle to-do item
      },
      links_find_in_range = 80, -- Link search range
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
        preserve_col = true
      }
    },
  },
  
  -- NERDTree - File explorer - MODIFIED TO LOAD AT STARTUP
  {
    "preservim/nerdtree",
    -- Removed cmd and keys options to prevent lazy loading
    init = function()
      vim.g.NERDTreeSortOrder = {[[\/$]], '[[-timestamp]]', '*'}
      vim.g.NERDTreeSortByTime = 1
      vim.g.NERDTreeShowHidden = 1  -- Show hidden files
    end,
    config = function()
      -- Auto open NERDTree when Vim starts
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.cmd("NERDTree")
          -- Move cursor to the main window if it exists
          vim.cmd("wincmd p")
        end,
      })
      
      -- Keymaps for NERDTree
      vim.keymap.set("n", "<leader>e", ":NERDTreeToggle<CR>", {silent = true, desc = "Toggle NERDTree"})
      vim.keymap.set("n", "<leader>f", ":NERDTreeFind<CR>", {silent = true, desc = "Find in NERDTree"})
      vim.keymap.set("n", "<leader>ns", function()
        if vim.g.NERDTreeSortByTime == 1 then
          vim.g.NERDTreeSortByTime = 0
          vim.g.NERDTreeSortOrder = {[[\/$]], '*'}
          print("NERDTree: Sorted alphabetically")
        else
          vim.g.NERDTreeSortByTime = 1
          vim.g.NERDTreeSortOrder = {[[\/$]], '[[-timestamp]]', '*'}
          print("NERDTree: Sorted by modification time (newest first)")
        end
        
        -- Refresh NERDTree
        vim.cmd([[
          if exists("b:NERDTree")
            call b:NERDTree.root.refresh()
            call NERDTreeRender()
          endif
        ]])
      end, {desc = "Toggle NERDTree sort mode"})
    end
  },
  
  -- Text manipulation plugins
  { "tpope/vim-commentary" },  -- Easy code commenting
  { "tpope/vim-surround" },    -- Surroundings manipulation
  { "jiangmiao/auto-pairs" },  -- Auto-close pairs
  
  -- Telescope and dependencies (FIXED)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = {"Telescope"}, -- Load on direct command too
    module = "telescope", -- Load when requiring the module
    keys = {
      { "<leader>ff", function() 
        require('telescope.builtin').find_files({previewer = false}) 
      end, desc = "Find files" },
      
      { "<leader>fg", function() 
        -- Use the utility function defined in global scope
        _G.telescope_custom_utils.throttle_live_grep()
      end, desc = "Live grep" },
      
      { "<leader>fb", function() 
        require('telescope.builtin').buffers({previewer = false}) 
      end, desc = "Buffers" },
      
      { "<leader>fh", function() 
        require('telescope.builtin').help_tags() 
      end, desc = "Help tags" },
      
      { "<leader>fd", function() 
        require('telescope.builtin').find_files({
          previewer = false, 
          cwd = vim.fn.expand("~/Documents")
        }) 
      end, desc = "Find in Documents" },
      
      { "<leader>fD", function() 
        require('telescope.builtin').live_grep({
          cwd = vim.fn.expand("~/Documents")
        }) 
      end, desc = "Grep in Documents" },
      
      { "<leader>bl", function() 
        -- Use the utility function defined in global scope
        _G.telescope_custom_utils.find_backlinks()
      end, desc = "Find backlinks" },
    },
    config = function()
      -- Attach our custom utils to telescope.utils
      local telescope = require('telescope')
      telescope.utils = telescope.utils or {}
      
      -- Register our custom functions in telescope.utils
      telescope.utils.throttle_live_grep = _G.telescope_custom_utils.throttle_live_grep
      telescope.utils.find_backlinks = _G.telescope_custom_utils.find_backlinks
      
      -- Telescope configuration with performance optimizations
      telescope.setup {
        defaults = {
          prompt_prefix = "❯ ",
          selection_caret = "❯ ",
          path_display = { "truncate" },
          
          -- Improved file ignoring patterns
          file_ignore_patterns = { 
            ".git/", "node_modules/", "target/", "docs/", ".settings/",
            "%.png", "%.jpg", "%.jpeg", "%.pdf", "%.zip", "%.tar.gz",
          },
          
          -- Improved ripgrep arguments for better performance
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '--glob=!.git/*',
            '--max-columns=150',         -- Limit line length
            '--max-columns-preview',
            '--trim',                    -- Trim whitespace
          },
          
          -- Set smaller timeouts
          cache_picker = {
            num_processes = 1,           -- Limit to one process
          },
          
          -- More aggressive preview optimizations
          preview = {
            timeout = 100,               -- Lower timeout for better performance
            treesitter = false,          -- Disable treesitter for preview
            filesize_limit = 1,          -- Limit previewed file size to 1MB
          },
          
          -- Throttle input for better performance
          set_env = { ['COLORTERM'] = 'truecolor' },
          
          -- Better layout performance
          layout_strategy = 'vertical',  -- Use vertical layout (often faster)
          layout_config = {
            vertical = {
              preview_cutoff = 40,       -- Don't show preview on small screens
              preview_height = 0.4,      -- Smaller preview size
            },
            height = 0.85,               -- Use less screen space
            width = 0.75,
          },
          
          buffer_previewer_maker = function(filepath, bufnr, opts)
            -- Skip preview for large files
            local previewers = require("telescope.previewers")
            local filesize = vim.fn.getfsize(filepath)
            
            if filesize > 100000 then
              -- Skip preview for files larger than 100KB
              return previewers.buffer_previewer_maker(filepath, bufnr, {
                bufname = "LARGE FILE",
                winblend = 0,
                preview_cutoff = 0,
                get_buffer_by_name = false
              })
            else
              previewers.buffer_previewer_maker(filepath, bufnr, opts)
            end
          end,
        },
        
        pickers = {
          find_files = { 
            theme = "dropdown",
            previewer = false,           -- Disable previewer for find_files
          },
          live_grep = {
            theme = "dropdown",
            only_sort_text = true,       -- Sort only by matched text (faster)
            disable_coordinates = true,  -- Don't show coordinates (faster)
          },
          buffers = {
            theme = "dropdown",
            previewer = false,           -- Disable previewer for buffers
            sort_lastused = true,
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
    end,
  },
  
  -- Completion plugins
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter", -- Lazy load on insert mode
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path", 
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
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
    end
  },

  -- Avante.nvim for AI-powered coding with Claude 3.7 Sonnet
  {
    "yetone/avante.nvim",
    event = "VeryLazy", -- Load after initial UI
    build = "make", -- Uses pre-built binaries
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim", 
      "MunifTanjim/nui.nvim",
      
      -- Optional but recommended for markdown rendering
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
      
      -- Optional for image pasting support
      {
        "HakonHarnes/img-clip.nvim",
        event = "BufEnter",
        opts = {
          default_dir = "assets",
        },
      },
    },
    opts = {
      provider = "openai", -- Set Claude as the default provider
      
      -- Claude specific configuration
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-5-sonnet-latest", -- Claude 3.7 Sonnet model string
        timeout = 60000, -- Increased timeout for this model (in milliseconds)
        temperature = 0, -- Set to 0 for most deterministic responses
        max_tokens = 8192, -- Increased token limit
      },
      
      -- OpenAI configuration as fallback
      openai = {
        endpoint = "https://api.openai.com/v1",
        model = "gpt-4o-mini", -- GPT-4o Mini for cost-effective performance
        timeout = 60000,
        temperature = 0,
        max_tokens = 4096,
      },
      
      behaviour = {
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        enable_token_counting = true,
        enable_cursor_planning_mode = true, -- Enable for better model compatibility
        enable_claude_text_editor_tool_mode = true, -- Enable Claude Text Editor Tool mode
        enable_rag = true, -- Enable RAG for better context-aware responses
      },
      
      -- RAG service configuration
      rag = {
        host_mount = vim.fn.expand("~/Documents"), -- Index documents from this directory
        llm_model = "gpt-3.5-turbo", -- Cost-effective model for RAG queries
        embed_model = "text-embedding-3-small", -- Efficient embedding model
      },
      
      mappings = {
        ask = "<leader>aa", -- Ask AI about code
        edit = "<leader>ae", -- Edit with AI assistance
        refresh = "<leader>ar", -- Refresh AI response
        diff = {
          ours = "co",
          theirs = "ct", 
          both = "cb",
          next = "]x",
          prev = "[x",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        toggle = {
          debug = "<leader>ad",
          hint = "<leader>ah",
          rag = "<leader>ag", -- Toggle RAG service
        },
        rag = {
          index = "<leader>ai", -- Manually trigger indexing
          query = "<leader>aq", -- Manually query the RAG service
        },
      },
    },
  },
})

-- Alt+] mapping for markdown files - move past closing ]]
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("i", "<M-]>", "<Esc>f]f]a", {buffer = true})
  end
})

-- Helper functions from init.vim converted to Lua
-- Format tags function
local function format_tags(tags_string)
  local trimmed = vim.fn.trim(tags_string)
  if trimmed == "" then
    return "[[]]"
  end
  
  local tags = vim.split(trimmed, ",")
  local formatted_tags = {}
  
  for _, tag in ipairs(tags) do
    local trimmed_tag = vim.fn.trim(tag)
    if trimmed_tag ~= "" then
      table.insert(formatted_tags, "[[" .. trimmed_tag .. "]]")
    end
  end
  
  return table.concat(formatted_tags, ", ")
end

-- Prompt for tags function
local function prompt_for_tags()
  local tags_input = vim.fn.input("Tags (separated by comma): ")
  return format_tags(tags_input)
end

-- Apply template function
local function apply_template(template, title)
  local template_path = vim.g.template_dir .. "/" .. template
  if vim.fn.filereadable(template_path) == 1 then
    -- Make sure we're at the start of the file
    vim.cmd("normal! gg")
    
    -- Read template file at the top of the buffer
    vim.cmd("0read " .. template_path)
    
    -- Get the title - either from the argument or the filename
    local file_title = title or vim.fn.expand("%:t:r")
    
    -- Prompt for tags
    local formatted_tags = prompt_for_tags()
    
    -- Expand common variables
    vim.cmd([[silent! %s/{{date}}/\=strftime('%Y-%m-%d')/ge]])
    vim.cmd([[silent! %s/{{title}}/]] .. vim.fn.escape(file_title, "/") .. [[/ge]])
    vim.cmd([[silent! %s/{{tags}}/]] .. vim.fn.escape(formatted_tags, "/") .. [[/ge]])
    
    -- Add a backlinks section at the end of the file
    vim.api.nvim_buf_set_lines(0, -1, -1, false, {"", "## Backlinks", ""})
    
    -- Position cursor at the cursor marker if it exists, otherwise at the end of file
    if vim.fn.search("{{cursor}}", "w") > 0 then
      -- Replace the marker with an empty string
      vim.cmd([[s/{{cursor}}//e]])
      -- Enter insert mode
      vim.cmd("startinsert")
    else
      -- Position cursor at the end of the file and enter insert mode
      vim.cmd("normal! G")
      vim.cmd("startinsert")
    end
    
    -- Mark as modified to ensure save works properly
    vim.opt.modified = true
  else
    print("Template not found: " .. template_path)
  end
end

-- Sanitize filename function
local function sanitize_filename(title)
  local sanitized = title:gsub("[^a-zA-Z0-9]", "_")
  return string.lower(sanitized)
end

-- Create and edit function
local function create_and_edit(file)
  local dir = vim.fn.fnamemodify(file, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
  vim.cmd("edit " .. file)
end

-- New markdown file function
local function new_markdown_file()
  local original_title = vim.fn.input("New Markdown file title: ")
  if original_title == "" then
    print("Cancelled")
    return
  end
  
  -- Create sanitized filename
  local filename = sanitize_filename(original_title) .. ".md"
  
  -- Set the global flag to prevent autocommand from applying template
  vim.g.markdown_template_applied = 1
  
  -- Create and edit the file
  create_and_edit(filename)
  
  -- Apply template with original title, not the filename
  apply_template("skeleton.md", original_title)
  
  -- Reset the flag for future file creations
  vim.defer_fn(function()
    vim.g.markdown_template_applied = 0
  end, 100)
end

-- Additional keymaps
-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Quick commands
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", {silent = true}) -- Clear search highlighting
vim.keymap.set("n", "<leader>w", ":w<CR>", {silent = true})         -- Quick save
vim.keymap.set("n", "<leader>q", ":q<CR>", {silent = true})         -- Quick quit
vim.keymap.set("n", "<leader>sv", ":source $MYVIMRC<CR>", {silent = true}) -- Source init.lua

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", {silent = true})
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", {silent = true})
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", {silent = true})

-- Add user commands for templates
vim.api.nvim_create_user_command("Template", function(opts)
  apply_template(opts.args)
end, {nargs = 1, complete = "file"})

vim.api.nvim_create_user_command("MDTemplate", function()
  apply_template("skeleton.md")
end, {})

vim.api.nvim_create_user_command("NewMarkdown", function()
  new_markdown_file()
end, {})

-- Template application
vim.keymap.set("n", "<leader>t", ":Template skeleton.md<CR>", {silent = true})
vim.keymap.set("n", "<leader>n", ":NewMarkdown<CR>", {silent = true})

vim.api.nvim_create_user_command("CE", function(opts)
  create_and_edit(opts.args)
end, {nargs = 1, complete = "file"})

-- Set up autocommands
local autocmd = vim.api.nvim_create_autocmd

-- Remember last cursor position
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line("$") then
      vim.cmd("normal! g'\"")
    end
  end,
})

-- Markdown-specific settings
autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 80
    vim.opt_local.conceallevel = 2
    vim.opt_local.autowriteall = true
    -- Enable automatic formatting for markdown files
    vim.opt_local.formatoptions:append("a") -- Auto-format paragraphs while typing
    vim.opt_local.formatoptions:append("t") -- Auto-wrap text using textwidth
    vim.opt_local.formatoptions:append("w") -- Trailing whitespace indicates paragraph continues
    vim.opt_local.formatoptions:append("q") -- Allow formatting of comments with gq
    -- Add markdown-specific mappings
    vim.keymap.set("i", ";l", "[]()<Left><Left><Left>", {buffer = true})
    vim.keymap.set("i", ";w", "[[]]<Left><Left>", {buffer = true})
    -- Add mapping to reformat current paragraph
    vim.keymap.set("n", "<leader>gq", "gqip", {buffer = true, desc = "Format current paragraph"})
  end,
})

-- Template for new markdown files
autocmd("BufNewFile", {
  pattern = "*.md",
  callback = function()
    if vim.g.markdown_template_applied == 0 then
      apply_template("skeleton.md")
    end
  end,
})

-- Load the status filter module
package.path = vim.fn.stdpath('config') .. '/lua/?.lua;' .. package.path
local ok, status_filter = pcall(require, 'markdown_status_filter')
if not ok then
  vim.notify("Could not load markdown_status_filter module", vim.log.levels.ERROR)
  status_filter = {
    filter_by_status = function() print("Status filter not available") end,
    count_status_types = function() print("Status counter not available") end
  }
else
  -- Status filter commands
  vim.api.nvim_create_user_command("StatusFilter", function(opts)
    status_filter.filter_by_status(opts.args)
  end, {nargs = 1})

  vim.api.nvim_create_user_command("StatusUnread", function()
    status_filter.filter_by_status("unread")
  end, {})

  vim.api.nvim_create_user_command("StatusWIP", function()
    status_filter.filter_by_status("wip")
  end, {})

  vim.api.nvim_create_user_command("StatusComplete", function()
    status_filter.filter_by_status("complete")
  end, {})

  vim.api.nvim_create_user_command("StatusAll", function()
    status_filter.filter_by_status("all")
  end, {})

  vim.api.nvim_create_user_command("StatusCount", function()
    status_filter.count_status_types()
  end, {})

  -- Key mappings for status filtering
  vim.keymap.set("n", "<leader>su", ":StatusUnread<CR>", {silent = true})
  vim.keymap.set("n", "<leader>sw", ":StatusWIP<CR>", {silent = true})
  vim.keymap.set("n", "<leader>sc", ":StatusComplete<CR>", {silent = true})
  vim.keymap.set("n", "<leader>sa", ":StatusAll<CR>", {silent = true})
  vim.keymap.set("n", "<leader>ss", ":StatusCount<CR>", {silent = true})
end

