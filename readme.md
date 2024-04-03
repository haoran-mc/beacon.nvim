- introduction: highlight you cursor when it jumps far.
- requirements: Neovim latest stable version or nightly.
- installtion(lazy.nvim): 

```lua
use { 'rainbowhxch/beacon.nvim' }`
```

- configuration:

```lua
require('beacon').setup({
	timeout = 500,
	ignore_buffers = {},
	ignore_filetypes = {},
})
```

- highlights

```vim
highlight Beacon guibg=white ctermbg=15
```
