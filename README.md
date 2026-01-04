# vim-monkeyc

Syntax highlighting and LSP support for **Garmin Monkey C** (Connect IQ) in Vim/Neovim.

![Monkey C Syntax Highlighting](https://github.com/philwi/vim-monkeyc/assets/screenshot.png)

## Features

- **Syntax highlighting** for `.mc` files
  - Keywords, types, and Toybox modules
  - Doc comments (`//!`) highlighted differently from regular comments
  - Garmin annotations (`(:annotation)`)
  - Proper number formats (hex, binary, float)
  - String escape sequences
  
- **LSP support** (Neovim 0.11+)
  - Auto-detects Connect IQ SDK location
  - Go to definition, references, hover docs
  - Diagnostics and code actions

- **Filetype settings**
  - Correct comment formatting for `gc` / `gcc`
  - 4-space indentation (Garmin standard)

## Installation

### lazy.nvim

```lua
{
  'philwi/vim-monkeyc',
  ft = 'monkeyc',
}
```

### vim-plug

```vim
Plug 'philwi/vim-monkeyc'
```

### packer.nvim

```lua
use { 'philwi/vim-monkeyc', ft = 'monkeyc' }
```

### Manual

```bash
git clone https://github.com/philwi/vim-monkeyc ~/.vim/pack/plugins/start/vim-monkeyc
```

## LSP Requirements

For LSP support (Neovim 0.11+ only):

1. **Java Runtime** - JDK 11 or newer
2. **Garmin Connect IQ SDK** - Download from [developer.garmin.com](https://developer.garmin.com/connect-iq/sdk/)

The plugin automatically searches for the SDK in `~/.Garmin/ConnectIQ/Sdks/`.

### Custom SDK Path

```lua
-- In your Neovim config, before loading the plugin:
vim.g.monkeyc_sdk_path = '/path/to/your/sdk'
```

### Disable LSP

```lua
vim.g.monkeyc_lsp_enabled = false
```

## Syntax Groups

| Group | Description |
|-------|-------------|
| `mcKeyword` | Language keywords (`class`, `function`, `if`, etc.) |
| `mcType` | Primitive types (`Number`, `String`, `Boolean`, etc.) |
| `mcModule` | Toybox modules (`WatchUi`, `Graphics`, `Sensor`, etc.) |
| `mcClass` | Common classes (`Dc`, `View`, `BehaviorDelegate`, etc.) |
| `mcConstant` | Constants (`true`, `false`, `null`) |
| `mcLineComment` | Regular comments (`// ...`) |
| `mcDocComment` | Documentation comments (`//! ...`) |
| `mcBlockComment` | Block comments (`/* ... */`) |
| `mcAnnotation` | Garmin annotations (`(:symbol)`) |
| `mcString` | String literals |
| `mcNumber` | Numeric literals |

## Customization

Override highlighting in your colorscheme:

```vim
" Make doc comments stand out more
hi mcDocComment guifg=#98c379 gui=italic

" Different color for Toybox modules
hi mcModule guifg=#e5c07b
```

## Related Projects

- [Garmin Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/)
- [Monkey C Language Reference](https://developer.garmin.com/connect-iq/monkey-c/)

## Contributing

Issues and PRs welcome! Please test with various `.mc` files from Connect IQ projects.

## License

MIT
