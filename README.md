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
2. Install ripgrep for optimal Telescope performance:

   ```bash
   # For Ubuntu/Debian
   sudo apt install ripgrep
   
   # For macOS
   brew install ripgrep
   
   # For Windows (with Chocolatey)
   choco install ripgrep
   ```

3. Clone this repository or copy the files to your Neovim configuration directory:

```bash
git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim
```

or manually copy the files to `~/.config/nvim/`.

4. Create a templates directory:

```bash
mkdir -p ~/.config/nvim/templates
```

5. Add at least a basic skeleton.md template to the templates directory.

6. Launch Neovim. Vim-plug will automatically install and plugins will be installed:

```bash
nvim
```

7. Inside Neovim, install all plugins:

```vim
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

The configuration includes NERDTree for file exploration with sorting by modification time:

- **Toggle**: Show/hide file explorer
- **Find Current File**: Locate the current file in the explorer
- **Sort by Modified Time**: Files are sorted by last modified time by default (newest first)
- **Toggle Sort Mode**: Switch between time-based and alphabetical sorting

### Key mappings:

- `<leader>e`: Toggle NERDTree
- `<leader>f`: Find current file in NERDTree
- `<leader>ns`: Toggle between time-based and alphabetical sorting

### Sort by Modified Time:

The configuration includes a custom function to sort files by modification time in NERDTree:

- Files are sorted with newest files at the top
- Directories always appear before files
- Toggle between time-based and alphabetical sorting with `<leader>ns`
- Visual feedback in the command line when toggling sort modes

```vim
" Set NERDTree to sort by timestamp (newest first)
let g:NERDTreeSortOrder = ['\/$', '[[-timestamp]]', '*']
```

## Telescope (Fuzzy Finder)

Integrated Telescope for powerful fuzzy finding, with performance optimizations for better responsiveness:

- **File Finding**: Fast file search without preview
- **Content Search**: Optimized live grep with throttling
- **Buffer Management**: Quick buffer switching without preview
- **Help Documentation**: Search available help topics
- **Document Search**: Performance-optimized search in Documents directory
- **Backlink Search**: Optimized search for references to current file

### Key mappings:

- `<leader>ff`: Find files (no preview for speed)
- `<leader>fg`: Throttled live grep (search file contents)
- `<leader>fb`: Search buffers (no preview for speed)
- `<leader>fh`: Search help tags
- `<leader>fd`: Search files in Documents (no preview)
- `<leader>fD`: Search content in Documents with optimized settings
- `<leader>bl`: Search for backlinks to current file

### Performance Features:

- **No Preview Mode**: Faster file finding without previews
- **Throttled Searching**: Better responsiveness during typing
- **File Ignoring**: Skip binaries, images, and large files automatically
- **Ripgrep Optimizations**: Limit line length, follow symbolic links
- **Large File Protection**: Skip preview for files over 100KB
- **Debounced Updates**: Reduced UI freezing during search

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
- `<leader>ff`: Find files (fast, no preview)
- `<leader>fg`: Throttled live grep (optimized content search)
- `<leader>fb`: Search buffers (fast, no preview)
- `<leader>fh`: Search help
- `<leader>fd`: Search in Documents directory (fast, no preview)
- `<leader>fD`: Throttled content search in Documents directory

## Performance Optimizations

Several optimizations for better performance, especially on lower-end hardware:

- **Memory Management**: Limited pattern matching memory usage with `set maxmempattern=2000`
- **Lazy Redraw**: Reduces unnecessary screen redraws with `set lazyredraw`
- **Telescope Optimizations**: 
  - No previewer for file finding (much faster)
  - Throttled live grep for responsive searching
  - File ignoring patterns for binaries and large files
  - Limited line length for ripgrep (faster searching)
  - Skipped preview for large files
  - Optimized layout configurations
- **Syntax Highlighting Limits**: Only highlight up to 200 columns with `set synmaxcol=200`
- **Conceallevel**: Set to 2 for markdown files to hide syntax for cleaner viewing
- **Ghost Text Disabled**: Turned off experimental features for better performance

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
- **throttled_live_grep**: Performance-optimized content searching
  - Usage: `<leader>fg`
- **NERDTreeToggleSortMode**: Toggle between time-based and alphabetical sorting in NERDTree
  - Usage: `<leader>ns`

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

5. **Telescope live grep is slow**: If live grep is still slow, make sure you have ripgrep installed:

```bash
# Check if ripgrep is installed
which rg

# If not, install it based on your OS
# For Ubuntu/Debian
sudo apt install ripgrep
```

Also check your file ignoring patterns to ensure you're not searching through large binary files or node_modules directories.

6. **NERDTree sorting not working**: If NERDTree sorting by modification time isn't working, try refreshing NERDTree with the `R` key while NERDTree is focused, or toggle the sort mode with `<leader>ns` and then back again.