#!/bin/bash

GITCONFIG_LOCAL="$HOME/.gitconfig.local"

if [ -f "$GITCONFIG_LOCAL" ]; then
    echo "$GITCONFIG_LOCAL already exists. Skip."
    exit 0
fi

echo "Setting up Git user identity (${GITCONFIG_LOCAL})..."
read -rp "user.name: " git_user_name
read -rp "user.email: " git_user_email

cat > "$GITCONFIG_LOCAL" <<EOF
[user]
    name = $git_user_name
    email = $git_user_email
EOF

echo "Wrote $GITCONFIG_LOCAL"
