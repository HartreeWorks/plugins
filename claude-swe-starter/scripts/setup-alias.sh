#!/bin/bash
# Add 'cc' alias for 'claude' command

# Detect shell config file
if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ] || [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
else
    echo "Could not detect shell config file. Add manually:"
    echo "  alias cc='claude'"
    exit 1
fi

# Check if alias already exists
if grep -q "alias cc='claude'" "$SHELL_RC" 2>/dev/null; then
    echo "Alias 'cc' already exists in $SHELL_RC"
    exit 0
fi

# Add the alias
echo "" >> "$SHELL_RC"
echo "# Claude Code alias" >> "$SHELL_RC"
echo "alias cc='claude'" >> "$SHELL_RC"

echo "Added alias 'cc' to $SHELL_RC"
echo "Run 'source $SHELL_RC' or restart your terminal to use it."
