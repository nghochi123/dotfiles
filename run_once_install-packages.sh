#!/bin/bash
set -euo pipefail

exist() {
    command -v "$1" > /dev/null 2>&1
}

log() {
    printf '\033[1;36m%s\033[0m %s\n' "$(date +%H:%M:%S)" "$1"
}

# Fresh-machine system packages are supported on Fedora (dnf).
install_system() {
    local executable="$1" package="$2"
    if ! exist "$executable"; then
        if ! exist dnf; then
            printf 'Install %s with your system package manager, then rerun chezmoi apply.\n' "$package" >&2
            exit 1
        fi
        sudo dnf install -y "$package"
    fi
}

install_cargo() {
    local executable="$1" package="$2"
    shift 2
    if ! exist "$executable"; then
        cargo install "$package" --locked "$@"
    fi
}

log "Installing missing dependencies..."
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.fzf/bin:$PATH"

install_system git git
install_system curl curl
install_system cc gcc
install_system c++ gcc-c++
install_system make make
install_system pkg-config pkgconf-pkg-config
install_system zsh zsh
install_system tmux tmux
install_system nvim neovim
install_system btop btop
install_system lazygit lazygit
install_system jq jq

if ! exist cargo; then
    installer=$(mktemp)
    trap 'rm -f "$installer"' EXIT
    curl -fsSL https://sh.rustup.rs -o "$installer"
    sh "$installer" -y --no-modify-path
fi
if [[ -r "$HOME/.cargo/env" ]]; then
    . "$HOME/.cargo/env"
fi

if ! exist fzf; then
    if [[ ! -d "$HOME/.fzf" ]]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    fi
    # Shell integration lives in our managed rc files.
    "$HOME/.fzf/install" --bin
fi

if [[ ! -r "$HOME/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    git clone --depth 1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
fi

# Test the installed files, not a nonexistent `tm` executable.
if [[ ! -r "$HOME/.tmux/.tmux.conf" ]]; then
    git clone --depth 1 https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
fi
if [[ ! -e "$HOME/.tmux.conf" && ! -L "$HOME/.tmux.conf" ]]; then
    ln -s .tmux/.tmux.conf "$HOME/.tmux.conf"
fi
if [[ ! -e "$HOME/.tmux.conf.local" && ! -L "$HOME/.tmux.conf.local" ]]; then
    cp "$HOME/.tmux/.tmux.conf.local" "$HOME/.tmux.conf.local"
fi

install_cargo fd fd-find
install_cargo bat bat
install_cargo rg ripgrep
install_cargo zoxide zoxide
install_cargo delta git-delta
install_cargo lsd lsd
install_cargo atuin atuin
install_cargo mise mise --features openssl/vendored
install_cargo yazi yazi-fm
install_cargo ya yazi-cli
install_cargo dust du-dust

log "Done."
