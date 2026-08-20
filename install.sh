#!/usr/bin/env bash
# Symlink the tracked dotfiles into $HOME.
#
# Idempotent: an existing correct symlink is left alone, a real file is moved
# to <name>.old before being replaced, and a MISSING file is created (the old
# version only linked files that already existed, so a fresh machine got
# nothing).
set -uo pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

FILES=".zshrc .zshenv .vimrc .tmux.conf .p10k.zsh"

for i in $FILES; do
    src="$BASEDIR/$i"
    dst="$HOME/$i"
    [[ -f "$src" ]] || { echo "skip $i (not in repo)"; continue; }

    if [[ -L "$dst" ]]; then
        if [[ "$(readlink "$dst")" == "$src" ]]; then
            echo "ok   $i (already linked)"
            continue
        fi
        echo "relink $i (was -> $(readlink "$dst"))"
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        echo "backup $i -> $i.old"
        mv "$dst" "$dst.old"
    else
        echo "new  $i"
    fi

    ln -s "$src" "$dst"
done
