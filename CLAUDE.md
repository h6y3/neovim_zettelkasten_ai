# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

- lint: No specific linting commands found
- format: No formatters detected
- test: No test commands found
- build: For Avante.nvim plugin: `cd ~/.local/share/nvim/lazy/avante.nvim && make BUILD_FROM_SOURCE=true`

## Style Guidelines

- **Indentation**: 2 spaces for Lua files
- **Naming**: Use snake_case for variables and functions
- **Functions**: Define local functions where possible
- **Error Handling**: Use pcall for error recovery in Lua
- **Comments**: Minimal comments, focus on clear, self-documenting code
- **Modules**: Use proper module patterns with local M = {} and return M
- **Plugin Config**: Keep plugin configurations in the lazy.nvim setup section

## Neovim Configuration

This is a Neovim configuration focused on Markdown editing, with specialized templates, status tracking, and integration with Claude AI.

When making code changes, focus on the smallest possible change for the task. If there is an opportunity to improve the code during the analysis flag it and then offer to improve the code first, test it, before making the feature change.

Code changes larger than 100 lines will require you to pause and ask to commit the code into GitHub before proceeding.
