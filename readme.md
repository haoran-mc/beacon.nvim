- introduction: highlight you cursor when it jumps far.
- requirements: Neovim latest stable version or nightly.
- installtion(lazy.nvim):

```lua
use { 'haoran-mc/beacon.nvim' }`
```

- configuration:

```lua
require('beacon').setup({
    timeout = 200,
    ignore_buffers = {},
    ignore_filetypes = {},
})
```

- highlight:

```vim
highlight Beacon guibg=white ctermbg=15
```

-----

you may be interested in the [zz branch](https://github.com/haoran-mc/beacon.nvim/tree/zz)

- usage:

```lua
vim.cmd("normal! zz")
```
