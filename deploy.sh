#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
    log_error "Dotfiles directory not found at $DOTFILES_DIR"
    exit 1
fi

# Function to create symlink with proper dot prefix
create_symlink() {
    local source="$1"
    local target="$2"

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"

    # Create symlink if it doesn't exist
    if [ ! -e "$target" ]; then
        log_info "Creating symlink: $target -> $source"
        ln -s "$source" "$target"
    elif [ ! -L "$target" ]; then
        log_warning "File exists but is not a symlink: $target"
    fi
}

# Handle config directory
if [ -d "$DOTFILES_DIR/config" ]; then
    find "$DOTFILES_DIR/config" -mindepth 1 -maxdepth 1 | while read -r item; do
        base_name=$(basename "$item")
        create_symlink "$item" "$HOME/.config/$base_name"
    done
fi

# Handle local directory
if [ -d "$DOTFILES_DIR/local" ]; then
    find "$DOTFILES_DIR/local" -mindepth 1 -maxdepth 2 | while read -r item; do
        rel_path="${item#$DOTFILES_DIR/local/}"
        create_symlink "$item" "$HOME/.local/$rel_path"
    done
fi

# Handle other dotfiles
find "$DOTFILES_DIR" -maxdepth 1 -type f -name ".*" | while read -r file; do
    base_name=$(basename "$file")
    create_symlink "$file" "$HOME/$base_name"
done

log_info "Deployment complete!"
