# Dotfiles

Managed with chezmoi. The active source directory is reported by
`chezmoi source-path` (normally `~/.local/share/chezmoi`). Edit that checkout;
other clones are not automatically synchronized.

## Updating

Review `chezmoi diff` before applying changes. To capture intentional live edits,
use `chezmoi add ~/.zshrc` (or the relevant file), then review the Git diff in
the source directory and commit it. Avoid keeping installer-generated changes
outside the managed source.

## Bootstrap

Install chezmoi, then run `chezmoi init --apply nghochi123`.
The package script supports Fedora through `dnf` and requires sudo access for
missing system packages. On other systems, install the reported dependencies
with the native package manager and rerun `chezmoi apply`.
Rust tools are installed through Cargo; building them can take several minutes.
Powerlevel10k, fzf, and Oh my tmux are fetched from their upstream repositories.
Existing installations are retained; tool upgrades are a separate operation.
Bun is optional and is not installed by the bootstrap script.

The installer stops on errors and only installs missing tools. Chezmoi tracks
successful `run_once_` script contents; editing the script causes it to run again.
To repair dependencies after a previously successful run, execute
`bash "$(chezmoi source-path)/run_once_install-packages.sh"` explicitly.

## Shell behavior

Zsh initializes completion before optional integrations. Ctrl-R opens Atuin when
installed (otherwise fzf); Up/Down search history by the current command prefix.
PATH entries are deduplicated in Zsh, and optional integrations are guarded.
The `gpf` alias uses `git push --force-with-lease`.
`away` and `home` refer to machine-local scripts in `~/.local/bin` that must be
provisioned separately. A Nerd Font is recommended for the configured prompt.

## Neovim

The configuration is aimed at a minimal Python IDE workflow. Pyright provides
language intelligence, Ruff provides diagnostics, and comma is the leader key.
For example, `<leader>ff` below means type `,ff` in normal mode. Pressing comma
by itself briefly displays available leader bindings through Which Key.

### Everyday workflow

| Binding | Mode | Action |
| --- | --- | --- |
| `-` | Normal | Open the current file's directory in Oil |
| `,e` | Normal | Toggle Oil in a floating window |
| `,ff` or `Ctrl-P` | Normal | Find a file |
| `,fg` | Normal | Search text across the working directory |
| `,fb` | Normal | Find an open buffer |
| `,r` | Normal | Save and run the current Python file |
| `,l` | Normal | Save and check the current Python file with Ruff |
| `gd` | Normal | Go to the symbol's definition |
| `gr` | Normal | Find references to the symbol |
| `K` | Normal | Show documentation for the symbol under the cursor |
| `F2` | Normal | Rename a symbol through the language server |
| `,d` | Normal | Show the diagnostic for the current line |
| `]d` / `[d` | Normal | Go to the next / previous diagnostic |
| `Ctrl-/` | Normal or visual | Toggle a line or selected lines as comments |
| `Ctrl-\` | Normal or terminal | Toggle the horizontal terminal |

Many terminals send `Ctrl-_` when `Ctrl-/` is pressed. Both encodings are
mapped to the same comment action.

### Python and Ruff

`,r` or `:RunFile` writes the current buffer and runs it with `python3`, falling
back to `python`. Output appears in a 15-line terminal split at the bottom. A
new run closes the previous runner terminal and stops its process if necessary.

`,l` or `:RuffCheck` writes the file and runs `ruff check`. The Ruff executable
installed by Mason or found on `PATH` is used first; when it is unavailable,
the command falls back to `uvx ruff check`. Both commands intentionally work
only for Python buffers.

The runner opens in terminal-input mode. Use `Ctrl-\ Ctrl-N` to enter normal
mode inside its terminal buffer, then `:q` to close the split. Use `Ctrl-\` to
toggle the separate general-purpose ToggleTerm terminal. LazyGit is available
from the shell as `lg`, or can be started inside a terminal with `lazygit`.

### Completion and indentation

Completion suggestions are not preselected, so `Enter` inserts a newline unless
you first select a suggestion. Select a completion using the menu's normal
navigation, then press `Enter` to accept it. The additional completion controls
are:

| Binding | Mode | Action |
| --- | --- | --- |
| `Ctrl-Space` | Insert | Open completion explicitly |
| `Ctrl-N` / `Ctrl-P` | Insert, completion visible | Select the next / previous suggestion |
| `Ctrl-U` | Insert, completion visible | Scroll documentation up |
| `Ctrl-D` | Insert, completion visible | Scroll documentation down |
| `Enter` | Insert | Accept an explicitly selected item; otherwise insert a newline |
| `Tab` | Insert | Keep normal Vim indentation behavior |
| `Tab` / `Shift-Tab` | Visual | Indent / unindent and keep the selection |

### Multiple cursors

Visual Multi provides the VS Code-style multi-selection workflow:

| Binding | Mode | Action |
| --- | --- | --- |
| `Ctrl-D` | Normal or visual | Select the word or selection under the cursor; repeat for the next match |
| `Ctrl-L` | Normal or visual | Select every matching occurrence |
| `Alt-Shift-Down` | Normal or visual | Add a cursor on the line below |
| `Alt-Shift-Up` | Normal or visual | Add a cursor on the line above |

After selecting occurrences, press `c` to replace their text, type the new
text, and press `Esc`. Pressing `i` inserts before every selected occurrence; it
does not replace the selected text. For example, place the cursor on `apple`,
press `Ctrl-D` for each desired match, then type `cpear<Esc>` to replace those
matches with `pear`. Press `Esc` again if needed to leave multiple-cursor mode.

### Language server

These bindings are available in a buffer after Pyright or Ruff attaches:

| Binding | Action |
| --- | --- |
| `gd` | Find definitions with Telescope |
| `gD` | Go to declaration |
| `gr` | Find references with Telescope |
| `gI` | Find implementations with Telescope |
| `gt` | Find type definitions with Telescope |
| `K` | Show hover documentation |
| `Ctrl-K` | Show signature help |
| `F2` | Rename symbol |
| `,ca` | Show available code actions |

### Diagnostics

Diagnostic signs and underlines are always visible. Messages at the end of a
line are disabled by default to keep the editor uncluttered.

| Binding | Action |
| --- | --- |
| `,d` | Open the diagnostic for the current line |
| `,D` | Search workspace diagnostics with Telescope |
| `[d` / `]d` | Go to the previous / next diagnostic |
| `,tv` | Toggle diagnostic messages at the end of affected lines |
| `,xd` | Toggle the current buffer's diagnostics in Trouble |
| `,xw` or `,xx` | Toggle workspace diagnostics in Trouble |

Telescope is useful for searching and jumping to one result. Trouble stays open
as a list, which is useful while fixing several diagnostics.

### Files, search, and buffers

| Binding | Action |
| --- | --- |
| `,ff` or `Ctrl-P` | Find files |
| `,fg` | Search file contents with live grep |
| `,fb` | Search open buffers |
| `,fr` | Search recently opened files |
| `,fh` | Search help topics |
| `,fc` | Search Git commits |
| `,fs` | Search changed Git files |

Inside Telescope, use `Ctrl-J` / `Ctrl-K` to move down / up, `Enter` to open a
result, and `Esc` to close the picker.

Oil treats a directory like an editable buffer. Edit filenames or directory
entries and write the buffer with `:w` to apply the filesystem changes.

| Binding in Oil | Action |
| --- | --- |
| `Enter` | Open the selected entry |
| `Ctrl-V` | Open in a vertical split |
| `Ctrl-S` | Open in a horizontal split |
| `Ctrl-T` | Open in a new tab |
| `-` | Go to the parent directory |
| `_` | Open Neovim's working directory |
| `g?` | Show Oil help |
| `q` | Close Oil |

### Buffers, movement, and jumps

| Binding | Mode | Action |
| --- | --- | --- |
| `Shift-H` / `Shift-L` | Normal | Go to the previous / next buffer |
| `,bp` / `,bn` | Normal | Go to the previous / next buffer |
| `,bd` | Normal | Close the current buffer |
| `,bD` | Normal | Force-close the current buffer |
| `,bo` | Normal | Close all other buffers |
| `,bl` / `,br` | Normal | Close buffers to the left / right |
| `,1` through `,5` | Normal | Go directly to buffer 1 through 5 |
| `Alt-Down` / `Alt-Up` | Normal | Move the current line down / up |
| `Alt-Down` / `Alt-Up` | Visual | Move the selection down / up |
| `s` | Normal, visual, or operator-pending | Jump to a visible location using Flash labels |
| `S` | Normal, visual, or operator-pending | Select or jump by syntax tree using Flash |

Search with `/` or `?` also uses Flash labels. While typing a search, `Ctrl-S`
toggles Flash for that search.

### Editing conveniences

The normal Comment.nvim bindings remain available: `gcc` toggles the current
line, while `gc` operates on a motion or visual selection. For example, `gcap`
toggles a paragraph and selecting lines followed by `gc` toggles that block.

The surround plugin uses standard surround verbs. `ys{motion}{character}` adds
a surround, `ds{character}` deletes one, and `cs{old}{new}` changes one. For
example, `ysiw"` quotes the current word, `ds"` removes its quotes, and `cs"'`
changes double quotes to single quotes.

### Messages

| Binding | Action |
| --- | --- |
| `,nl` | Show the last message |
| `,nh` | Open message history |
| `,nd` | Dismiss visible notifications |

Neovim's standard commands and motions still work. In particular, `u` undoes,
`Ctrl-R` redoes, `.` repeats the last change, `ciw` changes the current word,
`*` searches for the word under the cursor, `n` / `N` move through search
matches, and `zz` centers the current line.
