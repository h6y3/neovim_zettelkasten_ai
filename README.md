# Neovim Configuration for Markdown and Notes

A modern Neovim setup focused on Markdown editing, note-taking, and knowledge management with AI assistance from Claude 3.7 Sonnet. Features include template management, dynamic backlinks, status filtering, and optimized performance.

## Table of Contents

- [Installation](#installation)
- [Plugins](#plugins)
- [Core Features](#core-features)
  - [Seoul256 Color Scheme](#seoul256-color-scheme)
  - [Markdown Workflow](#markdown-workflow)
  - [Link Management](#link-management)
  - [Backlinks System](#backlinks-system)
  - [Status Management](#status-management)
  - [Templating System](#templating-system)
  - [AI-Powered Editing](#ai-powered-editing)
- [File Navigation](#file-navigation)
  - [NERDTree](#nerdtree)
  - [Telescope](#telescope)
- [Text Editing Enhancements](#text-editing-enhancements)
  - [Completion System](#completion-system)
  - [Text Manipulation](#text-manipulation)
- [Keyboard Shortcuts](#keyboard-shortcuts)
- [Performance Optimizations](#performance-optimizations)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)

## Installation

1. Ensure you have Neovim installed (version 0.10.1 or later required for Avante.nvim)
2. Install ripgrep for optimal Telescope performance:

   ```bash
   # For Ubuntu/Debian
   sudo apt install ripgrep
   
   # For macOS
   brew install ripgrep
   
   # For Windows (with Chocolatey)
   choco install ripgrep
   ```

3. Clone this repository to your Neovim configuration directory:

   ```bash
   git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim
   ```

4. Create the templates directory:

   ```bash
   mkdir -p ~/.config/nvim/templates
   ```

5. Copy the skeleton.md template to the templates directory.

6. Get an Anthropic API key (for Claude 3.7) from [Anthropic's website](https://console.anthropic.com/).

7. Launch Neovim. The lazy.nvim package manager will automatically install the plugins:

   ```bash
   nvim
   ```

## Plugins

This configuration uses lazy.nvim to manage the following plugins:

- **seoul256.vim**: Low-contrast color scheme for extended editing sessions
- **mkdnflow.nvim**: Advanced markdown workflow tools (using the dev branch)
- **NERDTree**: File explorer with time-based sorting
- **telescope.nvim**: Fuzzy finder with performance optimizations
- **nvim-cmp**: Completion framework with markdown-specific enhancements
- **LuaSnip**: Snippet engine for structured insertions
- **vim-commentary**: Easy code commenting
- **vim-surround**: Text surrounding manipulation
- **auto-pairs**: Auto-close brackets and quotes
- **avante.nvim**: AI-powered editing with Claude 3.7 Sonnet
- **render-markdown.nvim**: Enhanced markdown rendering
- **img-clip.nvim**: Image pasting support

## Core Features

### Seoul256 Color Scheme

A low-contrast color scheme that's easy on the eyes for extended editing sessions.

```lua
vim.opt.background = "dark"
vim.cmd([[colorscheme seoul256]])
```

### Markdown Workflow

Enhanced markdown editing powered by mkdnflow.nvim:

- Navigate between headings with `[[` and `]]`
- Follow links with `<CR>` or `<leader>fl`
- Create links with `<leader>cl`
- Jump between links with `<Tab>` and `<S-Tab>`
- Navigate back/forward with `<BS>` and `<Del>`
- Toggle to-do items with `<leader>tt`

The configuration includes special handling for wiki-style links `[[Like This]]` and standard markdown links `[Like This](like-this.md)`.

### Link Management

Intelligent link management with:

- Automatic link transformation (spaces → dashes, lowercase)
- Link concealing for cleaner document viewing
- Quick insertion shortcuts:
  - `;l` inserts `[]()`
  - `;w` inserts `[[]]`
- `<M-]>` moves past closing `]]`
- Custom completion for file links

### Backlinks System

Track references to your notes with:

- `<leader>bl`: Find all backlinks to the current file
- Automatic backlinks section in templates
- Automatic file saving when navigating (via autowriteall)

### Status Management

Track the progress of your notes with a custom status system:

- **unread**: Indicates that the file has not been read yet. It is typically used for notes or documents that the user intends to review later.
- **wip** (Work In Progress): Signifies that the file is still being worked on. It may contain incomplete thoughts, drafts, or ongoing projects that require further development.
- **complete**: Indicates that the file is finished and no further changes are expected. It is used for finalized notes or documents that are ready for reference or sharing.
- **delete**: Marks files that are candidates for deletion. This status helps identify content that is no longer needed or relevant but allows for review before permanent removal.

- Filter files by status (unread, wip, complete, delete)
- Count files by status with `<leader>ss`
- Change status directly from filter view with `<C-s>`
- View all statuses with `<leader>sa`

Key mappings:
- `<leader>su`: Show unread files
- `<leader>sw`: Show work-in-progress files
- `<leader>sc`: Show completed files
- `<leader>sd`: Show files marked for deletion

### Templating System

Create structured notes with a flexible templating system:

- Store templates in `~/.config/nvim/templates/`
- Apply templates with `<leader>t` or `:Template filename.md`
- Create new files with templates using `<leader>n` or `:NewMarkdown`
- Use variables like `{{date}}`, `{{title}}`, `{{tags}}`, and `{{cursor}}`
- Position cursor exactly where needed with the `{{cursor}}` marker
- Automatic tag formatting as `[[tag]]`

Example skeleton.md template:
```markdown
---
title: {{title}}
date: {{date}}
tags: {{tags}} 
status: unread
---

# {{title}} 

{{cursor}}

## Backlinks

```

### AI-Powered Editing

Leverage Claude 3.7 Sonnet for intelligent writing and coding assistance via avante.nvim:

- Ask AI about code/text with `<leader>aa`
- Edit with AI assistance using `<leader>ae`
- Refresh AI responses with `<leader>ar`
- Toggle RAG service with `<leader>ag`
- Index documents with `<leader>ai`
- Query the RAG service with `<leader>aq`

Features:
- Claude 3.7 Sonnet integration
- Retrieval Augmented Generation (RAG) for context-aware responses
- Text Editor Tool mode for precise editing
- Document indexing from your `~/Documents` directory
- Image support for better context

## File Navigation

### NERDTree

File explorer with time-based sorting:

- Toggle with `<leader>e`
- Find current file with `<leader>f`
- Toggle between time and alphabetical sorting with `<leader>ns`
- Files are sorted by modification time by default (newest first)

### Telescope

Optimized fuzzy finder for files and content:

- Find files with `<leader>ff` (no preview for speed)
- Search file contents with `<leader>fg` (throttled for responsiveness)
- List buffers with `<leader>fb`
- Search help tags with `<leader>fh`
- Search in Documents directory with `<leader>fd` (files) and `<leader>fD` (content)
- Find backlinks with `<leader>bl`

Performance optimizations:
- No previewer for faster file finding
- Throttled live grep for responsive content searching
- Intelligent file ignoring patterns
- Optimized ripgrep arguments
- Large file handling (>100KB files skip preview)

## Text Editing Enhancements

### Completion System

Intelligent completion with nvim-cmp:

- File link completion when typing `[[` or `[](` in markdown files
- Snippet support with LuaSnip
- Path completion
- Buffer word completion

Navigation:
- `<C-n>`, `<C-p>`: Navigate through completion menu
- `<Tab>`, `<S-Tab>`: Navigate through snippet placeholders
- `<C-Space>`: Trigger completion manually

### Text Manipulation

Text editing utilities:

- **vim-commentary**: Comment with `gcc` (line) or `gc` (visual selection)
- **vim-surround**: Manipulate surrounding characters
  - `cs"'`: Change surrounding quotes from " to '
  - `ds"`: Delete surrounding quotes
  - `ysiw]`: Surround word with brackets
- **auto-pairs**: Automatically insert closing brackets and quotes

### Markdown Formatting

Consistent text formatting for markdown files:

- Hard wrapping at 80 characters with `textwidth=80`
- Automatic paragraph formatting while typing with `formatoptions=atwq`:
  - `a`: Automatically format paragraphs as you type
  - `t`: Auto-wrap text using textwidth
  - `w`: Trailing whitespace indicates paragraph continues
  - `q`: Allow formatting of comments with `gq`
- Reformat existing paragraphs with `<leader>gq`
- Spell checking enabled by default
- Automatic file saving when navigating between files

## Keyboard Shortcuts

### General Navigation

- `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>`: Navigate between splits
- `<leader>bn`, `<leader>bp`: Navigate buffers (next/previous)
- `<leader>bd`: Delete buffer
- `<leader>h`: Clear search highlighting
- `<leader>w`: Save file
- `<leader>q`: Quit
- `<leader>sv`: Source init.lua

### Markdown Specific

- `<leader>n`: Create new markdown file with template
- `<leader>t`: Apply template to current file
- `;l`: Insert markdown link `[]()`
- `;w`: Insert wiki link `[[]]`
- `<M-]>`: Move past closing `]]`
- `<leader>fl`: Follow link
- `<leader>cl`: Create link
- `<leader>dl`: Destroy link (keep text)
- `<leader>tt`: Toggle to-do item
- `<leader>mt`: Mark selected text as span
- `]]`: Jump to next heading
- `[[`: Jump to previous heading
- `<leader>bl`: Search for backlinks
- `<leader>gq`: Reformat current paragraph to respect textwidth

### Status Management

- `<leader>su`: Show unread files
- `<leader>sw`: Show work-in-progress files
- `<leader>sc`: Show completed files
- `<leader>sd`: Show files marked for deletion
- `<leader>sa`: Show all files with status
- `<leader>ss`: Count files by status

### AI Assistant

- `<leader>aa`: Ask AI about code/text
- `<leader>ae`: Edit with AI assistance
- `<leader>ar`: Refresh AI response
- `<leader>ai`: Index documents for RAG
- `<leader>aq`: Query the RAG service
- `<leader>ag`: Toggle RAG service

### File Navigation

- `<leader>e`: Toggle NERDTree
- `<leader>f`: Find current file in NERDTree
- `<leader>ns`: Toggle NERDTree sort mode
- `<leader>ff`: Find files (fast, no preview)
- `<leader>fg`: Search file contents (throttled)
- `<leader>fb`: List buffers
- `<leader>fh`: Search help tags
- `<leader>fd`: Find files in Documents
- `<leader>fD`: Search contents in Documents

## Performance Optimizations

Optimizations for better performance, especially on lower-end hardware:

- **Memory Management**: Limited pattern matching memory with `maxmempattern=2000`
- **Lazy Redraw**: Reduces unnecessary screen redraws
- **Syntax Highlighting Limits**: Only highlight up to 200 columns
- **Telescope Optimizations**:
  - No previewer for file finding
  - Throttled live grep
  - Intelligent file ignoring
  - Limited line length for ripgrep
  - Skip preview for large files
- **Conceallevel**: Set to 2 for markdown files for cleaner reading
- **Markdown Specific**: Optimized markdown-specific settings

## Customization

You can customize this configuration by:

1. Editing `init.lua` directly
2. Adding custom templates to `~/.config/nvim/templates/`
3. Adjusting plugin settings in the lazy.nvim setup
4. Creating new key mappings for your workflow

### Adding a Custom Template

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

Use it with `:Template note.md`

## Troubleshooting

### Common Issues

1. **Missing dependencies**: Ensure ripgrep is installed for Telescope:
   ```bash
   # Check if ripgrep is installed
   which rg
   ```

2. **Template directory not found**: Create template directory:
   ```bash
   mkdir -p ~/.config/nvim/templates
   ```

3. **Link following not working**: Check that context is set properly in mkdnflow:
   ```lua
   links = {
       context = 2,  -- Needed for multi-line links
   }
   ```

4. **Slow performance in large directories**: Adjust Telescope ignoring patterns:
   ```lua
   file_ignore_patterns = {
       ".git/", "node_modules/", "target/", 
       -- Add patterns for large directories or files
   }
   ```

5. **Avante.nvim API key issues**: Make sure you've set up your Anthropic API key:
   ```bash
   # Set environment variable
   export ANTHROPIC_API_KEY="your_api_key_here"
   ```

6. **RAG functionality not working**: Ensure your Documents directory is properly set and contains relevant files.:
