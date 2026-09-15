#!/bin/bash

set -euo pipefail

setup_smart_renamer() {
    local repo_dir="$HOME/Documents/smart-renamer"

    read -rp "smart-renamer をセットアップしますか? [y/N] " answer
    case "$answer" in
        [yY]*) ;;
        *)
            echo "smart-renamer のセットアップをスキップしました。"
            return
            ;;
    esac

    if [ ! -d "$repo_dir" ]; then
        gh repo clone nagahamm/smart-renamer "$repo_dir"
    else
        echo "$repo_dir は既に存在します。cloneをスキップします。"
    fi

    bash "$repo_dir/setup.sh"
}

setup_smart_renamer
