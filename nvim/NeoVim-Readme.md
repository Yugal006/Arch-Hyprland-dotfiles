# Neovim Developer Showcase Configuration

A fully customized, plugin-rich Neovim setup focused on:

- Fast navigation (Telescope + key-driven workflow)
- LSP-powered development
- Modular plugin architecture (Lazy.nvim style)
- Minimal friction editing experience

---

# Design Philosophy

This configuration follows a strict priority model:

1. LSP Buffer Mappings (LspAttach)
2. User-defined keymaps (keymaps.lua)
3. Plugin default mappings
4. Fallback defaults (Neovim)

What you see is the actual runtime behavior, not theoretical plugin defaults.

---

# Leader Key System

```lua
vim.g.mapleader = " "
vim.g.maplocalleader = " "
````

Leader = Space

This setup is built around:

- `<leader>s` → Search system (Telescope)
    
- `<leader>l` → LSP-related actions
    
- `<leader>d` → Diagnostics
    
- `<leader>t` → Tabs / Toggles
    

---

# Core Neovim Keymaps (Global)

## File Operations

|Key|Action|
|---|---|
|`<C-s>`|Save file|
|`<leader>sn`|Save without auto-format|
|`<C-q>`|Quit|

---

## Navigation

|Key|Action|
|---|---|
|`<C-h/j/k/l>`|Window navigation|
|`<Tab>`|Next buffer|
|`<S-Tab>`|Previous buffer|
|`<leader>x`|Close buffer|

---

## Window Management

|Key|Action|
|---|---|
|`<leader>v`|Vertical split|
|`<leader>h`|Horizontal split|
|`<leader>se`|Equalize splits|
|`<leader>xs`|Close split|

---

## Tabs

|Key|Action|
|---|---|
|`<leader>to`|New tab|
|`<leader>tx`|Close tab|
|`<leader>tn`|Next tab|
|`<leader>tp`|Previous tab|

---

## Editing Enhancements

|Key|Action|
|---|---|
|`x`|Delete without yanking|
|`n / N`|Centered search navigation|
|`<C-d/u>`|Half-page scroll centered|

---

# Search System (Telescope Integration)

Powered by telescope.nvim

## Core Search

|Key|Action|
|---|---|
|`<leader>sf`|Find files|
|`<leader>sg`|Live grep|
|`<leader>sw`|Search word|
|`<leader>sh`|Help tags|
|`<leader>sk`|Keymaps|
|`<leader>sr`|Resume last search|
|`<leader>s.`|Recent files|
|`<leader><leader>`|Buffers|

---

## Advanced Search

|Key|Action|
|---|---|
|`<leader>/`|Fuzzy search in current buffer|
|`<leader>s/`|Search in open files|

---

# LSP System (Language Intelligence)

Powered by:

- Neovim LSP
    
- nvim-lspconfig
    
- Telescope integration
    

---

## Global LSP Keymaps

|Key|Action|
|---|---|
|`gd`|Go to definition|
|`gr`|References|
|`gI`|Implementation|
|`gD`|Declaration|
|`K`|Hover documentation|

---

## Workspace / Code Actions

|Key|Action|
|---|---|
|`<leader>rn`|Rename symbol|
|`<leader>ca`|Code action|
|`<leader>ws`|Workspace symbols|
|`<leader>ds`|Document symbols|
|`<leader>D`|Type definition|

---

## Diagnostics

|Key|Action|
|---|---|
|`[d`|Previous diagnostic|
|`]d`|Next diagnostic|
|`<leader>d`|Floating diagnostic|
|`<leader>q`|Diagnostics list|

---

## LSP Behavior Notes

- Highlights references on cursor hold
    
- Clears on movement
    
- Auto-detaches safely per buffer
    

---

# Comment System (comment.nvim)

## Normal Mode

|Key|Action|
|---|---|
|`<C-_>`|Toggle comment|
|`<C-c>`|Toggle comment|
|`<C-/>`|Toggle comment|

## Visual Mode

Same mappings apply to selected region.

---

# File Explorer (neo-tree.nvim)

## Global

|Key|Action|
|---|---|
|`<leader>e`|Toggle file explorer|
|`<leader>ngs`|Git status view|
|`\`|Reveal current file|

---

## Inside Neo-tree

Press `?` to view all mappings

|Key|Action|
|---|---|
|`<CR>`|Open file|
|`a`|Add file|
|`d`|Delete|
|`r`|Rename|
|`m`|Move|
|`c`|Copy|
|`s`|Vertical split|
|`t`|Open tab|
|`q`|Close|

---

# Autocompletion System

Powered by:

- nvim-cmp
    
- LuaSnip
    

## Insert Mode

|Key|Action|
|---|---|
|`<C-n>`|Next suggestion|
|`<C-p>`|Previous suggestion|
|`<C-y>`|Confirm selection|
|`<C-Space>`|Trigger completion|
|`<C-l>`|Expand/jump snippet|
|`<C-h>`|Jump backward snippet|

---

## Tab Behavior

|Key|Behavior|
|---|---|
|`<Tab>`|Next completion / snippet jump|
|`<S-Tab>`|Previous completion / snippet jump|

---

# Snippet Engine (LuaSnip)

- Expand snippets dynamically
    
- Jump between placeholders
    
- Choice node support enabled
    

---

# Terminal Mode

|Key|Action|
|---|---|
|`<Esc>`|Exit terminal mode|

---

# tmux Integration

|Key|Action|
|---|---|
|`<C-h>`|Move left|
|`<C-j>`|Move down|
|`<C-k>`|Move up|
|`<C-l>`|Move right|
|`<C-\>`|Previous pane|

---

# Key Architecture Summary

Priority Order (VERY IMPORTANT):

1. LSP Attach mappings (buffer local)
    
2. User keymaps.lua
    
3. Plugin mappings
    
4. Defaults
    

---

# Mental Model of This Setup

This config behaves like:

- Search → Telescope
    
- Navigation → Core keymaps
    
- Intelligence → LSP
    
- Structure → Neo-tree
    
- Productivity → Snippets + completion
    

Everything is either:

- A search
    
- A navigation
    
- A code-intent command
    

---

# Neovim Basics (Beginner Foundation Layer)

This section explains default Neovim behavior and mental model.

---

# Neovim Modes (Core Concept)

Neovim is modal:

## Normal Mode (n)

- Default mode
    
- Navigation + commands
    
- No text input
    

## Insert Mode (i)

- Writing text
    
- Enter via:
    
    - `i` insert before cursor
        
    - `a` insert after cursor
        
    - `o` new line below
        
- Exit: `<Esc>`
    

## Visual Mode (v)

Selection mode:

- `v` character selection
    
- `V` line selection
    
- `<C-v>` block selection
    

## Terminal Mode (t)

Inside terminal:

- `<Esc>` → exit to Normal mode
    

## Command Mode (:)

|Command|Meaning|
|---|---|
|`:w`|save|
|`:q`|quit|
|`:wq`|save + quit|
|`:q!`|force quit|

---

# Essential Beginner Commands

## File Operations

|Command|Meaning|
|---|---|
|`:w`|Save|
|`:q`|Quit|
|`:wq`|Save + quit|
|`:q!`|Force quit|
|`:e filename`|Open file|

---

## Copy / Paste / Delete

|Key|Action|
|---|---|
|`yy`|Copy line|
|`dd`|Delete line|
|`p`|Paste below|
|`P`|Paste above|
|`u`|Undo|
|`<C-r>`|Redo|

Note: some deletes use black-hole register to avoid clipboard overwrite.

---

## Movement

|Key|Action|
|---|---|
|`h`|left|
|`l`|right|
|`j`|down|
|`k`|up|
|`0`|start of line|
|`$`|end of line|
|`gg`|top|
|`G`|bottom|

---

## Search Basics

|Key|Action|
|---|---|
|`/text`|search forward|
|`?text`|search backward|
|`n`|next match|
|`N`|previous match|

---

# Core Concept

Everything in Neovim is a command:

- Movement = command
    
- Editing = command
    
- Plugins = commands
    
- LSP = commands
    
- Telescope = commands
    

Your config is a redesigned command system.

---

# How Your Setup Overrides Defaults

Examples:

- `n` → centered search navigation
    
- `x` → delete without yanking
    
- `<C-s>` → save file
    
- `<Tab>` → buffer switching
    

---

# Beginner Mental Model

Learn only:

1. Normal mode navigation
    
2. Insert mode editing
    
3. Command mode file control
    

Everything else is enhancement.

---

# Project Structure

```
.
├── init.lua
├── lazy-lock.json
└── lua
    ├── art
    │   ├── Akatsuki.lua
    │   ├── Boy1.lua
    │   ├── Cyberpunk.lua
    │   ├── Girl1.lua
    │   ├── Girl2.lua
    │   ├── Girl.lua
    │   ├── Luffy1.lua
    │   ├── Luffy.lua
    │   ├── Pokemon1.lua
    │   └── Pokemon.lua
    │
    ├── core
    │   ├── keymaps.lua
    │   ├── options.lua
    │   └── snippets.lua
    │
    └── plugins
        ├── alpha.lua
        ├── autocompletion.lua
        ├── bufferline.lua
        ├── cmp.lua
        ├── comment.lua
        ├── cyberdream.lua
        ├── gitsigns.lua
        ├── indent-blankline.lua
        ├── lsp.lua
        ├── lualine.lua
        ├── misc.lua
        ├── neotree.lua
        ├── none-ls.lua
        ├── telescope.lua
        └── treesitter.lua
```

---
