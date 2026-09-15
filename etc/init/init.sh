#!/bin/bash

DOTPATH="${DOTPATH:-$HOME/.dotfiles}"

setup_gitconfig_local() {
    local gitconfig_local="$HOME/.gitconfig.local"

    if [ -f "$gitconfig_local" ]; then
        echo "$gitconfig_local already exists. Skip."
        return
    fi

    echo "Setting up Git user identity (${gitconfig_local})..."
    read -rp "user.name: " git_user_name
    read -rp "user.email: " git_user_email

    cat > "$gitconfig_local" <<EOF
[user]
    name = $git_user_name
    email = $git_user_email
EOF

    echo "Wrote $gitconfig_local"
}

setup_iterm2_color_preset() {
    local itermcolors="$DOTPATH/mac/iterm2/iceberg.itermcolors"

    if [[ "$(uname)" != "Darwin" ]]; then
        return
    fi

    if defaults read com.googlecode.iterm2 "Custom Color Presets" 2>/dev/null | grep -q '^\s*iceberg = '; then
        echo "iTerm2 color preset 'iceberg' already imported. Skip."
        return
    fi

    echo "Importing iTerm2 color preset (${itermcolors})..."
    open "$itermcolors"
}

setup_gitconfig_local
setup_iterm2_color_preset
