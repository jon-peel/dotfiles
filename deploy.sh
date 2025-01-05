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

# Find all files/directories in the dotfiles repository
find "$DOTFILES_DIR" -mindepth 1 -maxdepth 4 -not -path "*/.git*" -not -name "*.sh" -not -path "*/backup*" | while read -r file; do
    # Get the relative path from dotfiles directory
    relative_path="${file#$DOTFILES_DIR/}"
    target="$HOME/$relative_path"

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"

    # Create symlink if it doesn't exist
    if [ ! -e "$target" ]; then
        log_info "Creating symlink for $relative_path"
        ln -s "$file" "$target"
    elif [ ! -L "$target" ]; then
        log_warning "File exists but is not a symlink: $target"
    fi
done

log_info "Deployment complete!"
