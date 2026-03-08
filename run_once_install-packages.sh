#!/bin/sh

exist() {
    command -v "$1" > /dev/null 2>&1
}

log() {
    printf "\033[1;36m%s\033[0m %s\n" "$(date +%H:%M:%S)" $1
}

log "Running..."

# Install fzf
if ! exist fzf; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi

# Install cargo
if ! exist cargo; then
    curl https://sh.rustup.rs -sSf | sh
fi

# Install oh my tmux
if ! exist tm; then
    curl -fsSL "https://github.com/gpakosz/.tmux/raw/refs/heads/master/install.sh#$(date +%s)" | bash
fi

# Install neovim

# Install fd
cargo install fd-find --locked

# Install bat
cargo install bat --locked

# Install ripgrep
cargo install ripgrep --locked

# Install zoxide
cargo install zoxide --locked

# Install delta
cargo install git-delta --locked

# Install lsd
cargo install lsd --locked

# Install atuin
cargo install atuin --locked

# Install mise
cargo install mise --features openssl/vendored --locked

log "Done."
