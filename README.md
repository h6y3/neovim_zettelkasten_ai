# Neovim Configuration

A clean, efficient Neovim setup focused on Markdown editing and templating, featuring the Seoul256 color scheme.

## Table of Contents

- [Installation](#installation)
- [Plugins](#plugins)
- [Seoul256 Color Scheme](#seoul256-color-scheme)
- [Markdown Workflow (mkdnflow)](#markdown-workflow-mkdnflow)
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
- [Custom Functions](#custom-functions)
- [Customization](#customization)

## Installation

1. Ensure you have Neovim installed (version 0.5.0 or later recommended).
2. Clone this repository or copy the files to your Neovim configuration directory:

 ```bash
git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim
 ```

 or manually copy the files to `~/.config/nvim/`.
3. Launch Neovim. Vim-plug will automatically install and plugins will be installed.

 ```bash
nvim
 ```

4. If plugins don't install automatically, run `:PlugInstall` within Neovim.

## Plugins

### Seoul256 Color Scheme

A low-contrast dark color scheme that's easy on the eyes.

- **Usage**: The color scheme is set automatically in the configuration.
- **Customization**: Adjust background darkness by setting `g:seoul256_background` between 233-239 (darker) or 252-256 (lighter) before the colorscheme is loaded.

### Markdown Workflow (mkdnflow)

Provides enhanced navigation and editing capabilities for Markdown files.

- **Navigation**:
- `<Enter>` - Follow links
- `<Tab>` - Jump to next link
- `<Shift-Tab>` - Jump to previous link
- `]]` - Jump to next heading
- `[[` - Jump to previous heading
- `<Backspace>` - Go back in navigation history
- `<Delete>` - Go forward in navigation history
- **Creating new files**:
- `<Space>nf` - Create a new Markdown file from the current buffer

### NERDTree (File Explorer)

A file system explorer for navigating the directory structure.

- **Toggle NERDTree**: `<Space>e`
- **Find current file in tree**: `<Space>f`
- **Basic operations within NERDTree**:
- `o` or `<Enter>` - Open files and directories
- `t` - Open in new tab
- `i` - Open in split
- `s` - Open in vertical split
- `I` - Toggle hidden files
- `R` - Refresh the tree
- `m` - Show the NERDTree menu (including file operations)

### Telescope (Fuzzy Finder)

Highly extendable fuzzy finder over lists.

- **Finding files**: `<Space>ff`
- **Searching text**: `<Space>fg` (requires ripgrep)
- **Listing buffers**: `<Space>fb`
- **Viewing help tags**: `<Space>fh`
- **Documents folder search**:
- `<Space>fd` - Find files in Documents folder
- `<Space>fD` - Search text in Documents folder
- **Inside Telescope**:
- `<Ctrl-n>/<Ctrl-p>` - Next/previous item
- `<Ctrl-c>` - Close telescope
- `<Enter>` - Select item
- `<Ctrl-x>` - Split horizontal
- `<Ctrl-v>` - Split vertical

### Text Manipulation Plugins

- **vim-commentary**:
- `gcc` - Comment/uncomment current line
- `gc` (visual mode) - Comment/uncomment selected lines
- **vim-surround**:
- `cs"'` - Change surrounding quotes from `"` to `'`
- `ds"` - Delete surrounding `"`
- `ysiw]` - Surround word with brackets
- `vS"` (visual mode) - Surround selection with `"`
- **auto-pairs**:
- Automatically inserts matching brackets, quotes, etc.
- `<Ctrl-h>` (insert mode) - Delete matching pairs
- `<Alt-p>` - Toggle auto-pairs

## Templating System

This configuration includes a robust templating system that makes it easy to start new files with predefined structures.

### Creating Templates

Templates are stored in `~/.config/nvim/templates/` and can be created for any file type.
The default template for Markdown files (`skeleton.md`) looks like:

```markdown
---
title: {{title}}
date: {{date}}
tags: {{tags}}
---
# {{title}}
```

To create a new template:

1. Create a file in the templates directory:

 ```bash
mkdir -p ~/.config/nvim/templates
nvim ~/.config/nvim/templates/meeting.md
 ```

2. Add your template content with optional variables like `{{date}}`, `{{title}}`, and `{{tags}}`.

### Using Templates

Templates can be applied in several ways:

1. **Automatic application**:

- New Markdown files will automatically use the `skeleton.md` template.
- Example: `nvim new-document.md`

2. **Manual application**:

- Apply the default Markdown template: `<Space>t` or `:MDTemplate`
- Apply a specific template: `:Template template-name.md`
- Example: `:Template meeting.md`

3. **Quick creation of new Markdown files**:

- Use `<Space>n` or `:NewMarkdown` to create a new Markdown file
- You'll be prompted for a filename (with tab completion support)
- The file will be created with directories if needed
- You'll be prompted to enter tags (comma-separated)
- The skeleton template will be automatically applied
- The cursor will be positioned at the end in insert mode

4. **Behavior**:

- Templates are inserted at the beginning of the file
- The cursor is positioned at the end of the file in insert mode
- The file is marked as modified so it can be saved

### Template Variables

Templates support variable expansion:

- `{{date}}` - Expands to the current date (format: YYYY-MM-DD)
- `{{title}}` - Expands to the filename without extension
- `{{tags}}` - Expands to formatted tags with double brackets
Example of how variables expand:
- For a file named `project-plan.md`, `{{title}}` becomes `project-plan`
- `{{date}}` always expands to the current date, e.g., `2023-03-09`
- For tags input `life, stoicism`, `{{tags}}` becomes `[[life]], [[stoicism]]`
You can add custom variables by modifying the `ApplyTemplate` function in `init.vim`.

### Tag System

The configuration includes a tag system for Markdown files:

- **When creating a new Markdown file**, you'll be prompted to enter tags
- **Format**: Enter tags as a comma-separated list (e.g., `productivity, notes, ideas`)
- **Automatic formatting**: Tags are automatically formatted with double brackets
- **Example**: Input `life, stoicism` becomes `[[life]], [[stoicism]]` in the front matter
- **Empty tags**: If no tags are entered, the template will include `[[]]` as a placeholder
- **Usage in templates**: Use the `{{tags}}` variable in your templates to include formatted tags

## Key Mappings

The leader key is set to the space bar (`<Space>`).

### General Navigation

- **Window navigation**:
- `<Ctrl-h>` - Move to left window
- `<Ctrl-j>` - Move to window below
- `<Ctrl-k>` - Move to window above
- `<Ctrl-l>` - Move to right window
- **Buffer navigation**:
- `<Space>bn` - Next buffer
- `<Space>bp` - Previous buffer
- `<Space>bd` - Delete buffer

### File Operations

- `<Space>w` - Quick save
- `<Space>q` - Quick quit
- `<Space>sv` - Source `init.vim` (reload configuration)
- `<Space>t` - Apply the Markdown template to current file
- `<Space>n` - Create a new Markdown file with template

### Markdown Specific

- All mkdnflow keybindings (see [Markdown Workflow](#markdown-workflow-mkdnflow))
- Spell checking is automatically enabled for Markdown files

### Searching

- `<Space>h` - Clear search highlighting
- Telescope keybindings (see [Telescope](#telescope-fuzzy-finder))

## Custom Functions

- **CreateAndEdit** (`CE` command):
- Creates directories if they don't exist when opening a file
- Example: `:CE path/that/doesnt/exist/yet/file.md`
- **NewMarkdownFile** (`:NewMarkdown` command):
- Interactive prompt for creating new Markdown files with the template
- Automatically adds .md extension if omitted
- Creates any necessary directories in the path
- Prompts for tags with comma-separated input
- Applies the skeleton.md template automatically
- **FormatTags**:
- Internal function that formats comma-separated tags with double brackets
- Example: `life, stoicism` → `[[life]], [[stoicism]]`
- **Document Search**:
- Custom functions for searching specifically in your Documents folder
- Accessed via `<Space>fd` for files and `<Space>fD` for text content

## Customization

To customize this configuration:

1. **Add new plugins**: Insert new `Plug` lines between the `plug#begin()` and `plug#end()` calls.
2. **Modify key bindings**: Add or change mappings in the "Key mappings" section.
3. **Add templates**: Create new files in the `~/.config/nvim/templates/` directory.
4. **Change template behavior**: Modify the `ApplyTemplate` function in `init.vim` to change how templates are applied or to add new template variables.
5. **Customize tag formatting**: Modify the `FormatTags` function to change how tags are formatted.
6. **Add file-specific settings**: Create new `autocmd` groups in the "Auto commands" section for different file types.

## Troubleshooting

- If plugins aren't working, try running `:PlugInstall` and restart Neovim.
- If templates aren't applying, check that the templates directory exists at `~/.config/nvim/templates/`.
- For Telescope issues with searching text, ensure `ripgrep` is installed on your system.
- If tag prompts appear twice when creating a file, ensure your init.vim contains the fix for preventing duplicate template application.
