# UnoCSS Language Server

A language server for unocss

## Features

<img width="200" src="https://raw.githubusercontent.com/xna00/unocss-language-server/main/res/nvim-html.gif">

<img width="200" src="https://raw.githubusercontent.com/xna00/unocss-language-server/main/res/highlight.png">


* Simple completion
* Hover
* Loading config from `root dir`
* Highlight color (use with [mrshmllow/document-color.nvim](https://github.com/mrshmllow/document-color.nvim))

## Install

```sh
npm i unocss-language-server -g
```

**For Nix users:**

```sh
# Install
nix profile install github:xna00/unocss-language-server

# or just run without installing
nix run github:xna00/unocss-language-server -- --stdio
```

## Usage

[nvim-lspconfig server_configuration](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#unocss)
```lua
require 'lspconfig'.unocss.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { ... },
  root_dir = function(fname)
    return require 'lspconfig.util'.root_pattern(...)(fname)
  end
}
```
If you are using [nvim-cmp](https://github.com/hrsh7th/nvim-cmp), you can add `-` to [trigger_characters](https://github.com/hrsh7th/nvim-cmp/blob/main/doc/cmp.txt#L528).
```lua
cmp.setup {
  sources = { { name = 'nvim_lsp', trigger_characters = { '-' } } }
}
```
Because `@unocss/autocomplete` suggest less before meeting `-`.

### CoC (coc.nvim)

To use the language server with coc.nvim, add the following to your `coc-settings.json`.
CoC connects to the server over stdio, so make sure to include the `--stdio` argument.

```json
{
  "languageserver": {
    "unocss": {
      "command": "unocss-language-server",
      "args": [
        "--stdio"
      ],
      "filetypes": [
        "typescriptreact",
        "javascriptreact",
        "vue",
        "svelte"
      ]
    }
  }
}
```

## Related information

* [Language Server Extension Guide](https://code.visualstudio.com/api/language-extensions/language-server-extension-guide)
* [Language Server Protocol Specification](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/)
* [Lsp - Neovim docs](https://neovim.io/doc/user/lsp.html)
