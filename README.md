# Neovim Configuration

A clean, efficient Neovim setup focused on Markdown editing and templating, featuring the Seoul256 color scheme with enhanced markdown link autocompletion and backlink features.

## Table of Contents

- [Installation](#installation)
- [Plugins](#plugins)
- [Seoul256 Color Scheme](#seoul256-color-scheme)
- [Markdown Workflow (mkdnflow)](#markdown-workflow-mkdnflow)
- [Markdown Link Autocompletion](#markdown-link-autocompletion)
- [Backlinks System](#backlinks-system)
- [NERDTree (File Explorer)](#nerdtree-file-explorer)
- [Telescope (Fuzzy Finder)](#telescope-fuzzy-finder)
- [Text Manipulation Plugins](#text-manipulation-plugins)
- [Templating System](#templating-system)
- [Creating Templates](#creating-templates)
- [Using Templates](#using-templates)
- [Template Variables](#template-variables)
- [Tag System](#tag-system)
- [Key Mappings](#key-mappings)
- [General Navigation](#general-navigation)
- [File Operations](#file-operations)
- [Markdown Specific](#markdown-specific)
- [Searching](#searching)
- [Performance Optimizations](#performance-optimizations)
- [Custom Functions](#custom-functions)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)

## Installation

1. Ensure you have Neovim installed (version 0.7.0 or later recommended for full mkdnflow functionality).
2. Clone this repository or copy the files to your Neovim configuration directory:

```bash
git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim
```

or manually copy the files to `~/.config/nvim/`.

3. Create a templates directory:

```bash
mkdir -p ~/.config/nvim/templates
```

4. Add at least a basic skeleton.md template to the templates directory.

5. Launch Neovim. Vim-plug will automatically install and plugins will be installed:

```bash
nvim
```

6. Inside Neovim, install all plugins:

```
:PlugInstall
```

## Plugins

This configuration includes the following plugins:

- **seoul256.vim**: A low-contrast color scheme for Vim
- **mkdnflow.nvim**: Markdown workflow enhancement (using the development branch for latest features)
- **nvim-cmp**: Autocompletion framework with custom markdown link source
- **LuaSnip**: Snippet engine for autocompletion
- **NERDTree**: File explorer
- **vim-commentary**: Easy code commenting
- **vim-surround**: Text surrounding operations
- **auto-pairs**: Auto-close brackets and quotes
- **telescope.nvim**: Fuzzy finder for files and text
- **plenary.nvim**: Lua utilities (required by telescope)

## Seoul256 Color Scheme

The configuration uses the Seoul256 color scheme, a low-contrast Vim color scheme that works well for extended editing sessions. The dark mode is enabled by default:

```vim
set background=dark
silent! colorscheme seoul256
```

## Markdown Workflow (mkdnflow)

The configuration integrates [mkdnflow.nvim](https://github.com/jakewvincent/mkdnflow.nvim) for enhanced Markdown editing with the following features:

- **Link Navigation**: Quickly move between and follow links
- **Link Transformation**: Convert spaces to dashes and lowercase for filenames
- **Link Concealing**: Hide markdown syntax for cleaner reading
- **Multi-line Links**: Support for links that span multiple lines with context=2 setting
- **Heading Navigation**: Jump between headings with `[[` and `]]`
- **File Creation**: Create new markdown files from links
- **Wiki-style Links**: Support for `[[WikiLinks]]` format in addition to standard Markdown links

### Key mappings:

- `<CR>`: Follow link under cursor
- `<Tab>`: Go to next link
- `<S-Tab>`: Go to previous link
- `<BS>`: Go back after following a link
- `<Del>`: Go forward in navigation history
- `<leader>fl`: Alternative follow link command
- `<leader>cl`: Create link from selected text
- `<leader>dl`: Destroy link but keep text
- `<leader>mt`: Mark selected text as a span
- `<leader>tt`: Toggle to-do item

## Markdown Link Autocompletion

The configuration includes a custom completion system for markdown links:

- **Auto-suggestion**: Shows existing markdown files when typing `[[` or `[](` 
- **Snippet Support**: Use Tab to navigate through link placeholders
- **Smart Completion**: Context-aware completion that only activates in markdown files
- **Path Intelligence**: Shows both file names and relative paths in completion menu

### Key mappings and shortcuts:

- `;l`: Insert a standard markdown link `[]()`
- `;w`: Insert a wiki-style link `[[]]`
- `<C-Space>`: Trigger completion manually
- `<C-n>`, `<C-p>`: Navigate through completion menu
- `<Tab>`, `<S-Tab>`: Navigate through snippet placeholders
- When typing `[[` or `[](`, completion menu appears automatically

## Backlinks System

A dynamic backlink system to find references between markdown files:

- **Backlink Search**: Find all references to the current file using Telescope
- **Template Integration**: Templates include a backlinks section
- **Automatic File Saving**: Files are automatically saved when navigating between them

### Key mappings:

- `<leader>bl`: Search for all references to the current file
- `:set autowriteall`: Automatically enabled for markdown files to ensure changes are saved when navigating

## NERDTree (File Explorer)

The configuration includes NERDTree for file exploration:

- **Toggle**: Show/hide file explorer
- **Find Current File**: Locate the current file in the explorer

### Key mappings:

- `<leader>e`: Toggle NERDTree
- `<leader>f`: Find current file in NERDTree

## Telescope (Fuzzy Finder)

Integrated Telescope for powerful fuzzy finding:

- **File Finding**: Search for files by name
- **Content Search**: Search for patterns within files
- **Buffer Management**: Search open buffers
- **Help Documentation**: Search available help topics
- **Document Search**: Search specifically within Documents directory
- **Backlink Search**: Search for references to current file
- **Performance Optimizations**: Configured for better performance on lower-end hardware

### Key mappings:

- `<leader>ff`: Find files
- `<leader>fg`: Live grep (search file contents)
- `<leader>fb`: Search buffers
- `<leader>fh`: Search help tags
- `<leader>fd`: Search files in Documents
- `<leader>fD`: Search content in Documents
- `<leader>bl`: Search for backlinks to current file

## Text Manipulation Plugins

Several plugins to enhance text editing capabilities:

- **vim-commentary**: Comment code with `gcc` (line) or `gc` (visual selection)
- **vim-surround**: Manipulate surrounding characters (parentheses, quotes, tags)
  - `cs"'`: Change surrounding quotes from " to '
  - `ds"`: Delete surrounding quotes
  - `ysiw]`: Surround word with brackets
- **auto-pairs**: Automatically insert closing brackets, quotes, etc.

## Templating System

A flexible templating system for creating new markdown files:

- **Predefined Templates**: Store templates in `~/.config/nvim/templates/`
- **Variables**: Use `{{date}}`, `{{title}}`, `{{tags}}`, and `{{cursor}}` in templates
- **Cursor Positioning**: Precisely control where the cursor appears after template insertion
- **Tag System**: Easily add formatted tags to new files
- **Backlinks Section**: Templates now include a backlinks section
- **Path Creation**: Automatically creates directories if they don't exist

### Creating Templates

Add templates to the `~/.config/nvim/templates/` directory. For example, create a `skeleton.md` file:

```markdown
# {{title}}

Date: {{date}}
Tags: {{tags}}

## Content
{{cursor}}

## Backlinks

```

The `{{cursor}}` marker will be replaced with an empty string, and the cursor will be positioned exactly at that location in insert mode after applying the template.

### Using Templates

- `<leader>t`: Apply the default template
- `<leader>n`: Create a new markdown file with template
- `:Template filename.md`: Apply a specific template
- `:MDTemplate`: Apply skeleton.md template to current file

### Template Variables

- `{{date}}`: Current date (formatted as YYYY-MM-DD)
- `{{title}}`: Title from filename or specified during creation
- `{{tags}}`: Tags specified during template application
- `{{cursor}}`: Specifies where the cursor should be positioned after applying the template

## Tag System

The configuration includes a tagging system for markdown files:

- **Tag Formatting**: Tags are automatically formatted as `[[tag]]`
- **Tag Input**: Enter tags separated by commas when creating a file
- **Tag Prompt**: Automatically prompted to enter tags when using templates

## Key Mappings

### General Navigation

- `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`: Navigate between splits
- `<leader>bn`, `<leader>bp`: Navigate buffers (next/previous)
- `<leader>bd`: Delete buffer

### File Operations

- `<leader>w`: Save file
- `<leader>q`: Quit
- `<leader>sv`: Source vimrc

### Markdown Specific

- `<leader>n`: Create new markdown file
- `<leader>t`: Apply template to current file
- `;l`: Insert markdown link `[]()`
- `;w`: Insert wiki link `[[]]`
- `<leader>bl`: Search for backlinks
- `<leader>cl`: Create link
- `<leader>fl`: Follow link
- `<leader>dl`: Destroy link
- `]]`: Jump to next heading
- `[[`: Jump to previous heading

### Searching

- `<leader>h`: Clear search highlighting
- `<leader>ff`: Find files
- `<leader>fg`: Search in files
- `<leader>fb`: Search buffers
- `<leader>fh`: Search help
- `<leader>fd`: Search in Documents directory
- `<leader>fD`: Search content in Documents directory

## Performance Optimizations

Several optimizations for better performance, especially on lower-end hardware:

- **Memory Management**: Limited pattern matching memory usage with `set maxmempattern=2000`
- **Lazy Redraw**: Reduces unnecessary screen redraws with `set lazyredraw`
- **Telescope Optimizations**: 
  - Reduced preview timeouts (200ms)
  - Limited concurrent processes (single process for cache)
  - Disabled treesitter for preview
  - Optimized layout configurations
- **Syntax Highlighting Limits**: Only highlight up to 200 columns with `set synmaxcol=200`
- **Conceallevel**: Set to 2 for markdown files to hide syntax for cleaner viewing

## Custom Functions

The configuration includes several custom functions:

- **CreateAndEdit**: Create directories and edit files in one command
  - Usage: `:CE path/to/new/file.md`
- **NewMarkdownFile**: Create a new markdown file with template
  - Usage: `:NewMarkdown` or `<leader>n`
- **SearchInDocuments/GrepInDocuments**: Search specifically in Documents directory
  - Usage: `:DocFiles` or `<leader>fd` (files)
  - Usage: `:DocGrep` or `<leader>fD` (content)
- **find_backlinks**: Find all references to current file using Telescope
  - Usage: `<leader>bl`

## Customization

You can customize this configuration by:

1. Editing the `init.vim` file directly
2. Adding your own templates to the templates directory
3. Adjusting plugin settings in the Lua blocks
4. Adding or removing plugins in the vim-plug section

### Example: Adding a Custom Template

Create a new template in `~/.config/nvim/templates/`:

```bash
echo '# {{title}}

Created: {{date}}
Tags: {{tags}}

## Summary
{{cursor}}

## Details

## Related

## Backlinks
' > ~/.config/nvim/templates/note.md
```

Then use it with `:Template note.md`. The cursor will be automatically positioned after "## Summary" in insert mode.

## Troubleshooting

### Common Issues

1. **Error with mkdnflow functions**: If you see errors related to mkdnflow functions not being found, make sure you're using the latest version of the plugin and have specified the `dev` branch:

```vim
Plug 'jakewvincent/mkdnflow.nvim', { 'branch': 'dev' }
```

2. **Autowriting not working**: If files aren't saving automatically when navigating, check that `autowriteall` is set for markdown files:

```vim
" Add this to your configuration if needed
autocmd FileType markdown setlocal autowriteall
```

3. **Template directory not found**: If templates aren't working, ensure your template directory exists:

```bash
mkdir -p ~/.config/nvim/templates
```

4. **Links not working**: If link following isn't working, check that you have context set properly in the mkdnflow configuration:

```lua
links = {
    context = 2,  -- Needed for multi-line links
    -- other settings...
}
```