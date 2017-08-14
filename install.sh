#!/usr/bin/env bash

# SUUUUPER simple, for now

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

FILES=".zshrc .vimrc .tmux.conf .java8rc .java7rc"


for i in $FILES; do
    if [[ -f "$HOME/$i" ]]; then
        if [[ ! -L "$HOME/$i" ]]; then
            # not a link, move it out of the way
            mv $HOME/$i $HOME/$i.old
        else
            # it's a link, continue
            continue
        fi
        ln -s $BASEDIR/$i $HOME/$i
    fi
done

