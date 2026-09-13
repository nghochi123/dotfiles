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

The comma key is the leader. Use `,D` for workspace diagnostics, `,d` for the
diagnostic under the cursor, and `[d`/`]d` to move between diagnostics. Trouble
provides `,xd` for the current buffer and `,xw` for the workspace. Diagnostic
signs and underlines are always visible; `,tv` toggles messages at the end of
each affected line.

Use `,r` or `:RunFile` to save and run the current Python file in a terminal
split. Use `,l` or `:RuffCheck` to check it with Ruff; the Mason-installed Ruff
is preferred, with `uvx ruff check` as a fallback.

In normal or visual mode, Ctrl-D selects the next matching occurrence and
Ctrl-L selects all occurrences. Alt-Shift-Down/Up adds cursors vertically.
Enter accepts a completion only after one has been selected; otherwise it
inserts a newline. Tab retains its normal indentation behavior.
