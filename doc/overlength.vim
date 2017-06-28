(This is just a copy of my readme. Sorry ¯\_(ツ)_/¯ )

## overlength.vim

Highlight when lines go over the length that you want them.

### Usage

This plugin is on by default when you install it :smile:

To toggle or turn it off, you can do the following:

`call overlength#toggle()`:
- Function to turn on and off overlength highlighting
- Example: `call overlength#toggle()`
- Alternatives: `call overlength#disable()` or `call overlength#enable()`

### Configuration

`overlength#default_to_textwidth`:
- (Setting): Default to using the `&textwidth` option as the column to start drawing the overlength highlighting
  - Options:
    - `0`: Don't use `&textwidth` at all. Always use `overlength#default_overlength`.
    - `1`: Use `&textwidth`, unless it's 0, then use `overlength#default_overlength`.
    - `2`: Always use `&textwidth`. There will be no highlighting where `&textwidth == 0`, unless added explicitly
- Default: `1`
- Example: `let overlength#default_to_textwidth = 0`

`call overlength#set_overlength(filetype, length)`:
- Function to set a specific overlength value for a filetype
  - If set to 0, then overlength will not highlight for that buffer
- Example: `call overlength#set_overlength('python', 120)`

`overlength#default_overlength`:
- Setting to decide the default length when there is no filetype specific request
  - Depends on `overlength#default_to_textwidth` to be on an applicable setting
- Default: `80`
- Example: `let overlength#default_overlength = 72`

`call overlength#set_highlight(cterm, guibg)`:
- Function to change the highlighting background by specifying a `cterm` and `guibg`
- Example: `call overlength#set_highlight('darkgrey', '#8b0000')`

