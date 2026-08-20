#!/usr/bin/env bash
# Symlink the tracked dotfiles into $HOME.
#
# Idempotent: an existing correct symlink is left alone, a real file is moved
# to <name>.old before being replaced, and a MISSING file is created (the old
# version only linked files that already existed, so a fresh machine got
# nothing).
set -uo pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

FILES=".zshrc .zshenv .vimrc .tmux.conf .p10k.zsh .gitconfig"

# Per-host opt-out: .nolink.<hostname> lists files this machine must NOT have
# linked (one per line), for configs that still need a real merge.
NOLINK="$BASEDIR/.nolink.$(hostname -s)"

for i in $FILES; do
    src="$BASEDIR/$i"
    dst="$HOME/$i"
    [[ -f "$src" ]] || { echo "skip $i (not in repo)"; continue; }
    if [[ -f "$NOLINK" ]] && grep -qxF "$i" "$NOLINK"; then
        echo "SKIP $i (listed in .nolink.$(hostname -s))"
        continue
    fi

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

# Host-specific overrides: .gitconfig.<hostname> in this repo becomes
# ~/.gitconfig.local, which the shared .gitconfig [include]s. Machines with no
# such file get nothing -- a missing git include is a silent no-op.
host_src="$BASEDIR/.gitconfig.$(hostname -s)"
host_dst="$HOME/.gitconfig.local"
if [[ -f "$host_src" ]]; then
    if [[ -L "$host_dst" && "$(readlink "$host_dst")" == "$host_src" ]]; then
        echo "ok   .gitconfig.local (already linked)"
    else
        [[ -e "$host_dst" && ! -L "$host_dst" ]] && mv "$host_dst" "$host_dst.old"
        ln -sfn "$host_src" "$host_dst"
        echo "link .gitconfig.local -> .gitconfig.$(hostname -s)"
    fi
else
    echo "ok   no host-specific gitconfig for $(hostname -s)"
fi
