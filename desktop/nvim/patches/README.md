# Patches

Local fixes for archived or unmaintained plugins that won't receive upstream updates.

---

## nvim-treesitter-nvim012.patch

**Plugin:** nvim-treesitter  
**Affects:** Neovim 0.12+  
**File patched:** `lua/nvim-treesitter/query_predicates.lua`

### What it fixes

Neovim 0.12 removed the `all` option from `add_directive`/`add_predicate`.
Match callbacks now always receive `TSNode[]` arrays instead of a single `TSNode`.
nvim-treesitter was not updated for this (the master branch was archived in May 2025),
causing a crash whenever treesitter injection queries run (e.g. opening a markdown file):

```
attempt to call method 'range' (a nil value)
```

### How to apply

Run from the nvim-treesitter plugin directory:

```sh
cd ~/.local/share/nvim/lazy/nvim-treesitter
git apply ~/.config/nvim/patches/nvim-treesitter-nvim012.patch
```

Or with the system `patch` command:

```sh
cd ~/.local/share/nvim/lazy/nvim-treesitter
patch -p1 < ~/.config/nvim/patches/nvim-treesitter-nvim012.patch
```
