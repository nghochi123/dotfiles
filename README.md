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
