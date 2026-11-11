# snacks-tabs.nvim

Tab page picker for [snacks.nvim](https://github.com/folke/snacks.nvim).

snacks.nvim has no tabs picker
([folke/snacks.nvim#660](https://github.com/folke/snacks.nvim/issues/660)),
so this plugin adds one as a regular snacks source. It opens with
`Snacks.picker.tabs()`, shows up in `Snacks.picker.pickers()`, and keeps its own
resume state and search history.

Each tab is listed with its number, the file in its current window (previewed),
and the names of the other files open in that tab.

## Requirements

- Neovim >= 0.10
- [snacks.nvim](https://github.com/folke/snacks.nvim) with the picker enabled

## Installation

[lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "miki725/snacks-tabs.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {},
    keys = {
        { "<leader>ft", function() Snacks.picker.tabs() end, desc = "Tabs" },
    },
}
```

`setup()` registers the source. Any options are merged into the source, so
everything from the
[snacks picker config](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md)
applies:

```lua
opts = {
    title = "Tab pages",
    layout = { preset = "select" },
}
```

### Without setup

The source is also exposed as a table, so it can go straight into the snacks
config. The plugin then loads the first time the picker opens:

```lua
{
    "folke/snacks.nvim",
    opts = {
        picker = {
            sources = {
                tabs = {
                    config = function(opts)
                        return vim.tbl_deep_extend("force", opts, require("snacks-tabs").source)
                    end,
                },
            },
        },
    },
}
```

## Keys

| Key     | Mode         | Action                    |
| ------- | ------------ | ------------------------- |
| `<CR>`  | input / list | Switch to the tab         |
| `<c-x>` | input        | Close the selected tab(s) |
| `dd`    | list         | Close the selected tab(s) |

These match the snacks buffers picker. Closing is skipped for the last
remaining tab. To use a different key:

```lua
opts = {
    win = {
        input = { keys = { ["<c-d>"] = { "tab_close", mode = { "n", "i" } } } },
    },
}
```

## Health

```vim
:checkhealth snacks-tabs
```
